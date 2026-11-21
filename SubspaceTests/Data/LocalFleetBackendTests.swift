//
//  LocalFleetBackendTests.swift
//  SubspaceTests
//
//  Created by Clifton Baggerman on 30/10/2026.
//

import Foundation
import Testing
@testable import Subspace

@Suite("Local Fleet Backend")
struct LocalFleetBackendTests {
    private func makeSubject(storeURL: URL? = nil) -> LocalFleetBackend {
        LocalFleetBackend(storeURL: storeURL)
    }

    private func request(
        _ method: String,
        _ path: String,
        body: [String: Any]? = nil,
        token: String? = nil
    ) throws -> LocalFleetRequest {
        LocalFleetRequest(
            method: method,
            pathComponents: path.split(separator: "/").map(String.init),
            bearerToken: token,
            body: try body.map { try JSONSerialization.data(withJSONObject: $0) }
        )
    }

    private func decode<T: Decodable>(_ type: T.Type, from response: LocalFleetResponse) throws -> T {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(type, from: response.body)
    }

    @Test
    func `Logs in with the advertised crew credentials`() async throws {
        let subject = makeSubject()

        let response = await subject.respond(
            to: try request("POST", "auth/login", body: ["email": "picard@starfleet.com", "password": "engage"])
        )

        #expect(response.statusCode == 200)
        #expect(try decode(AuthResponse.self, from: response).user.name == "Jean-Luc Picard")
    }

    @Test
    func `Rejects a wrong password`() async throws {
        let subject = makeSubject()

        let response = await subject.respond(
            to: try request("POST", "auth/login", body: ["email": "picard@starfleet.com", "password": "wrong"])
        )

        #expect(response.statusCode == 401)
    }

    @Test
    func `Restores the current user from its token`() async throws {
        let subject = makeSubject()
        let login = await subject.respond(
            to: try request("POST", "auth/login", body: ["email": "demo@example.com", "password": "password"])
        )
        let token = try decode(AuthResponse.self, from: login).accessToken

        let response = await subject.respond(to: try request("GET", "auth/me", token: token))

        #expect(try decode(User.self, from: response).id == "demo")
    }

    @Test
    func `Registers a new officer who can then log in`() async throws {
        let subject = makeSubject()
        let details = ["name": "Wesley Crusher", "email": "wesley@starfleet.com", "password": "shutup"]

        let registration = await subject.respond(to: try request("POST", "auth/register", body: details))
        let login = await subject.respond(
            to: try request("POST", "auth/login", body: ["email": "wesley@starfleet.com", "password": "shutup"])
        )

        #expect(registration.statusCode == 200)
        #expect(login.statusCode == 200)
    }

    @Test
    func `Refuses to register the same personnel ID twice`() async throws {
        let subject = makeSubject()
        let details = ["name": "Impostor", "email": "picard@starfleet.com", "password": "secret"]

        let response = await subject.respond(to: try request("POST", "auth/register", body: details))

        #expect(response.statusCode == 409)
    }

    @Test
    func `Lists the crew`() async throws {
        let subject = makeSubject()

        let response = await subject.respond(to: try request("GET", "users"))

        #expect(try decode(ListResponse<User>.self, from: response).data.count == 8)
    }

    @Test
    func `Serves messages that decode as the client expects, newest first`() async throws {
        let subject = makeSubject()

        let response = await subject.respond(to: try request("GET", "users/picard/messages"))
        let messages = try decode(ListResponse<MessageResponse>.self, from: response).data
        let fresh = try decode(FreshListResponse<FreshMessageResponse>.self, from: response).data

        #expect(!messages.isEmpty)
        #expect(fresh.count == messages.count)
        #expect(messages.map(\.createdAt) == messages.map(\.createdAt).sorted(by: >))
    }

    @Test
    func `Marking a message read lowers the unread count`() async throws {
        let subject = makeSubject()
        let list = await subject.respond(to: try request("GET", "users/data/messages"))
        let unread = try #require(try decode(ListResponse<MessageResponse>.self, from: list).data.first { !$0.isRead })
        let before = await subject.respond(to: try request("GET", "users/data/messages/unread-count"))

        _ = await subject.respond(to: try request("PATCH", "messages/\(unread.id)/read"))
        let after = await subject.respond(to: try request("GET", "users/data/messages/unread-count"))

        #expect(try decode(UnreadCountResponse.self, from: after).unreadCount ==
            decode(UnreadCountResponse.self, from: before).unreadCount - 1)
    }

    @Test
    func `Archiving flags the message`() async throws {
        let subject = makeSubject()
        let list = await subject.respond(to: try request("GET", "users/worf/messages"))
        let message = try #require(try decode(ListResponse<MessageResponse>.self, from: list).data.first)

        _ = await subject.respond(to: try request("PATCH", "messages/\(message.id)/archive"))
        let updated = await subject.respond(to: try request("GET", "users/worf/messages"))

        let archived = try decode(ListResponse<MessageResponse>.self, from: updated).data.first { $0.id == message.id }
        #expect(archived?.isArchived == true)
    }

    @Test
    func `Sending a message stores it and draws a crew reply`() async throws {
        let subject = makeSubject()
        let before = await subject.respond(to: try request("GET", "users/troi/messages"))
        let count = try decode(ListResponse<MessageResponse>.self, from: before).data.count

        let response = await subject.respond(
            to: try request("POST", "messages", body: ["userId": "troi", "content": "Hello", "kind": "error", "isRead": false])
        )
        let after = await subject.respond(to: try request("GET", "users/troi/messages"))

        #expect(try decode(MessageResponse.self, from: response).content == "Hello")
        #expect(try decode(ListResponse<MessageResponse>.self, from: after).data.count == count + 2)
    }

    @Test
    func `Rejects message kinds the real backend would reject`() async throws {
        let subject = makeSubject()

        let response = await subject.respond(
            to: try request("POST", "messages", body: ["userId": "troi", "content": "Hello", "kind": "normal"])
        )

        #expect(response.statusCode == 400)
    }

    @Test(arguments: MessageKindOption.allCases)
    func `Every composable message kind is accepted`(kind: MessageKindOption) async throws {
        let subject = makeSubject()

        let response = await subject.respond(
            to: try request("POST", "messages", body: ["userId": "troi", "content": "Hello", "kind": kind.apiKind])
        )

        #expect(response.statusCode == 200)
    }

    @Test
    func `Keeps sent messages across launches`() async throws {
        let storeURL = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        defer { try? FileManager.default.removeItem(at: storeURL) }

        _ = await makeSubject(storeURL: storeURL).respond(
            to: try request("POST", "messages", body: ["userId": "riker", "content": "Number one", "kind": "info"])
        )
        let response = await makeSubject(storeURL: storeURL).respond(to: try request("GET", "users/riker/messages"))

        let messages = try decode(ListResponse<MessageResponse>.self, from: response).data
        #expect(messages.contains { $0.content == "Number one" })
    }

    @Test
    func `Answers unknown routes with 404`() async throws {
        let response = await makeSubject().respond(to: try request("GET", "warp/core"))

        #expect(response.statusCode == 404)
    }
}

@Suite("Local Fleet Over HTTP")
struct LocalFleetURLProtocolTests {
    @Test
    func `The real API client reaches the fleet at its own address`() async throws {
        let client = APIClient(baseURL: AppConfiguration.localFleetURL, urlSession: .localFleet)

        let users = try await client.fetchUsers()

        #expect(!users.data.isEmpty)
    }

    @Test
    func `Request bodies survive the trip through URLSession`() async throws {
        let client = APIClient(baseURL: AppConfiguration.localFleetURL, urlSession: .localFleet)
        let body = try JSONEncoder().encode(["email": "demo@example.com", "password": "password"])

        let response: AuthResponse = try await client.request("auth/login", method: .post, body: body, includeAuth: false)

        #expect(response.user.id == "demo")
    }
}

@Suite("Request Cancellation")
struct RequestCancellationTests {
    private final class HangingProtocol: URLProtocol {
        override static func canInit(with request: URLRequest) -> Bool { true }
        override static func canonicalRequest(for request: URLRequest) -> URLRequest { request }
        override func startLoading() {}
        override func stopLoading() {}
    }

    @Test
    func `A cancelled request is reported as cancellation, not failure`() async {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [HangingProtocol.self]
        let session = URLSession(configuration: configuration)
        let client = APIClient(baseURL: AppConfiguration.localFleetURL, urlSession: session)

        let task = Task {
            try await client.requestWithRetry("users") as ListResponse<User>
        }
        task.cancel()
        let result = await task.result

        #expect(throws: CancellationError.self) {
            try result.get()
        }
    }
}

@Suite("Message Filters")
struct MessageFilterTests {
    private func message(kind: String = "info", isRead: Bool = false, isArchived: Bool? = nil) -> MessageResponse {
        MessageResponse(
            id: "1",
            userId: "picard",
            content: "Test",
            kind: kind,
            isRead: isRead,
            createdAt: "",
            updatedAt: "",
            isArchived: isArchived
        )
    }

    @Test
    func `Priority shows messages composed as priority`() {
        #expect(MessageFilter.priority.includes(message(kind: MessageKindOption.priority.apiKind)))
        #expect(!MessageFilter.priority.includes(message(kind: MessageKindOption.normal.apiKind)))
    }

    @Test
    func `Unread hides read messages`() {
        #expect(MessageFilter.unread.includes(message()))
        #expect(!MessageFilter.unread.includes(message(isRead: true)))
    }

    @Test(arguments: [MessageFilter.all, .unread, .priority])
    func `Archived messages leave the live filters`(filter: MessageFilter) {
        #expect(!filter.includes(message(kind: "error", isArchived: true)))
    }

    @Test
    func `Archive shows only archived messages`() {
        #expect(MessageFilter.archived.includes(message(isArchived: true)))
        #expect(!MessageFilter.archived.includes(message()))
    }
}

@Suite("Open-Meteo Forecasts")
struct OpenMeteoServiceTests {
    @Test
    func `Decodes daily temperatures`() throws {
        let json = Data(#"""
        {"daily":{"time":["2026-10-30","2026-10-31"],
        "temperature_2m_max":[24.5,26.0],"temperature_2m_min":[16.6,17.0]}}
        """#.utf8)

        let forecasts = try OpenMeteoService.forecasts(from: json)

        #expect(forecasts.map(\.max) == [24.5, 26.0])
        #expect(forecasts.map(\.min) == [16.6, 17.0])
    }

    @Test
    func `Rejects a malformed response`() {
        #expect(throws: (any Error).self) {
            try OpenMeteoService.forecasts(from: Data("{}".utf8))
        }
    }
}

@Suite("Stardate")
struct StardateTests {
    private var calendar: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "UTC") ?? .current
        return calendar
    }

    @Test
    func `The first day of a year is a round thousand`() throws {
        let date = try #require(calendar.date(from: DateComponents(year: 2026, month: 1, day: 1)))

        #expect(Stardate.string(for: date, calendar: calendar) == "44000.0")
    }

    @Test
    func `Stardates advance through the year`() throws {
        let date = try #require(calendar.date(from: DateComponents(year: 2026, month: 7, day: 2)))

        #expect(Stardate.string(for: date, calendar: calendar) == "44498.6")
    }
}
