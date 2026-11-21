//
//  LocalFleetBackend.swift
//  Subspace
//
//  Created by Clifton Baggerman on 30/10/2026.
//

import Foundation
import os

// MARK: - Backend

/// Answers the Subspace API on the device, so the app works without a server
actor LocalFleetBackend {
    // MARK: - Properties

    static let shared = LocalFleetBackend(storeURL: defaultStoreURL)

    private static let tokenPrefix = "local-fleet-"

    /// The same kinds the real backend accepts, so offline mode cannot hide a client mistake
    private static let messageKinds: Set<String> = ["info", "warning", "error", "success"]

    private let storeURL: URL?
    private let now: @Sendable () -> Date
    private let logger = Logger(subsystem: "Subspace", category: "LocalFleetBackend")
    private var state: LocalFleetState

    // MARK: - Initialization

    /// Initializes the backend, restoring any saved state
    /// - Parameters:
    ///   - storeURL: Where to persist state, or nil to keep it in memory only
    ///   - now: Clock used to timestamp new records
    init(storeURL: URL?, now: @escaping @Sendable () -> Date = { Date() }) {
        self.storeURL = storeURL
        self.now = now
        self.state = Self.loadState(from: storeURL) ?? Self.seededState(now: now())
    }

    // MARK: - Routing

    /// Routes a request to the handlers for its resource
    func respond(to request: LocalFleetRequest) -> LocalFleetResponse {
        switch request.pathComponents.first {
        case "auth":
            return routeAuth(request)
        case "users":
            return routeUsers(request)
        case "messages":
            return routeMessages(request)
        default:
            return failure(status: 404)
        }
    }

    private func routeAuth(_ request: LocalFleetRequest) -> LocalFleetResponse {
        switch (request.method, Array(request.pathComponents.dropFirst())) {
        case ("POST", ["login"]):
            return login(request)
        case ("POST", ["register"]):
            return register(request)
        case ("POST", ["refresh"]):
            return refresh(request)
        case ("POST", ["logout"]):
            return encoded(["status": "ok"])
        case ("GET", ["me"]):
            return currentUser(request)
        default:
            return failure(status: 404)
        }
    }

    private func routeUsers(_ request: LocalFleetRequest) -> LocalFleetResponse {
        let path = Array(request.pathComponents.dropFirst())
        guard request.method == "GET" else {
            return failure(status: 404)
        }

        switch path.count {
        case 0:
            return listUsers()
        case 1:
            return user(id: path[0])
        case 2 where path[1] == "messages":
            return listMessages(userId: path[0])
        case 3 where path[1] == "messages" && path[2] == "unread-count":
            return unreadCount(userId: path[0])
        default:
            return failure(status: 404)
        }
    }

    private func routeMessages(_ request: LocalFleetRequest) -> LocalFleetResponse {
        let path = Array(request.pathComponents.dropFirst())

        if request.method == "POST", path.isEmpty {
            return createMessage(request)
        }
        guard request.method == "PATCH", path.count == 2 else {
            return failure(status: 404)
        }

        switch path[1] {
        case "read":
            return updateMessage(id: path[0]) { $0.isRead = true }
        case "archive":
            return updateMessage(id: path[0]) {
                $0.isRead = true
                $0.isArchived = true
            }
        default:
            return failure(status: 404)
        }
    }
}

// MARK: - Authentication

extension LocalFleetBackend {
    private struct Credentials: Decodable {
        let email: String
        let password: String
    }

    private struct Registration: Decodable {
        let name: String
        let email: String
        let password: String
    }

    private struct RefreshRequest: Decodable {
        let refreshToken: String
    }

    private func login(_ request: LocalFleetRequest) -> LocalFleetResponse {
        guard let credentials = decode(Credentials.self, from: request),
              let account = account(email: credentials.email),
              account.password == credentials.password else {
            return failure(status: 401)
        }
        return authResponse(for: account.user)
    }

    private func register(_ request: LocalFleetRequest) -> LocalFleetResponse {
        guard let registration = decode(Registration.self, from: request) else {
            return failure(status: 400)
        }
        guard account(email: registration.email) == nil else {
            return failure(status: 409)
        }

        let user = User(
            id: "crew-\(UUID().uuidString.lowercased())",
            name: registration.name,
            email: registration.email,
            avatarURL: nil,
            createdAt: now()
        )
        state.accounts.append(LocalFleetAccount(user: user, password: registration.password))
        state.messages.append(contentsOf: LocalFleetSeed.messages(for: user.id, now: now()))
        persist()
        return authResponse(for: user)
    }

    private func refresh(_ request: LocalFleetRequest) -> LocalFleetResponse {
        guard let refresh = decode(RefreshRequest.self, from: request),
              let user = user(fromToken: refresh.refreshToken) else {
            return failure(status: 401)
        }
        return authResponse(for: user)
    }

    private func currentUser(_ request: LocalFleetRequest) -> LocalFleetResponse {
        guard let token = request.bearerToken, let user = user(fromToken: token) else {
            return failure(status: 401)
        }
        return encoded(user)
    }

    private func authResponse(for user: User) -> LocalFleetResponse {
        let token = Self.tokenPrefix + user.id
        return encoded(AuthResponse(user: user, accessToken: token, refreshToken: token))
    }

    private func account(email: String) -> LocalFleetAccount? {
        state.accounts.first { $0.user.email.caseInsensitiveCompare(email) == .orderedSame }
    }

    private func user(fromToken token: String) -> User? {
        guard token.hasPrefix(Self.tokenPrefix) else {
            return nil
        }
        let userId = String(token.dropFirst(Self.tokenPrefix.count))
        return state.accounts.first { $0.user.id == userId }?.user
    }
}

// MARK: - Users

extension LocalFleetBackend {
    private struct UserList: Encodable {
        let data: [User]
        let total: Int
        let limit: Int
        let offset: Int
    }

    private func listUsers() -> LocalFleetResponse {
        let users = state.accounts.map(\.user)
        return encoded(UserList(data: users, total: users.count, limit: users.count, offset: 0))
    }

    private func user(id: String) -> LocalFleetResponse {
        guard let user = state.accounts.first(where: { $0.user.id == id })?.user else {
            return failure(status: 404)
        }
        return encoded(user)
    }
}

// MARK: - Messages

extension LocalFleetBackend {
    private struct MessageList: Encodable {
        let data: [LocalFleetMessage]
        let total: Int
        let limit: Int
        let offset: Int
    }

    private struct UnreadCount: Encodable {
        let unreadCount: Int
    }

    private struct NewMessage: Decodable {
        let userId: String
        let content: String
        let kind: String
    }

    private func listMessages(userId: String) -> LocalFleetResponse {
        let messages = state.messages
            .filter { $0.userId == userId }
            .sorted { $0.createdAt > $1.createdAt }
        return encoded(MessageList(data: messages, total: messages.count, limit: messages.count, offset: 0))
    }

    private func unreadCount(userId: String) -> LocalFleetResponse {
        let count = state.messages.filter { $0.userId == userId && !$0.isRead && !$0.isArchived }.count
        return encoded(UnreadCount(unreadCount: count))
    }

    private func createMessage(_ request: LocalFleetRequest) -> LocalFleetResponse {
        guard let newMessage = decode(NewMessage.self, from: request),
              Self.messageKinds.contains(newMessage.kind) else {
            return failure(status: 400)
        }

        let sentAt = now()
        let draft = LocalFleetSeed.MessageDraft(content: newMessage.content, kind: newMessage.kind, isRead: true)
        let message = LocalFleetSeed.message(for: newMessage.userId, draft: draft, at: sentAt)
        let replyCount = state.messages.filter { $0.userId == newMessage.userId }.count
        let reply = LocalFleetSeed.reply(to: newMessage.userId, sequence: replyCount, at: sentAt.addingTimeInterval(1))

        state.messages.append(contentsOf: [message, reply])
        persist()
        return encoded(message)
    }

    private func updateMessage(id: String, change: (inout LocalFleetMessage) -> Void) -> LocalFleetResponse {
        guard let index = state.messages.firstIndex(where: { $0.id == id }) else {
            return failure(status: 404)
        }

        change(&state.messages[index])
        state.messages[index].updatedAt = LocalFleetSeed.timestamp(now())
        persist()
        return encoded(["status": "ok"])
    }
}

// MARK: - Encoding

extension LocalFleetBackend {
    private func decode<T: Decodable>(_ type: T.Type, from request: LocalFleetRequest) -> T? {
        guard let body = request.body else {
            return nil
        }
        return try? JSONDecoder().decode(type, from: body)
    }

    private func encoded(_ value: some Encodable) -> LocalFleetResponse {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601

        do {
            return LocalFleetResponse(statusCode: 200, body: try encoder.encode(value))
        } catch {
            logger.error("Failed to encode response: \(error.localizedDescription, privacy: .public)")
            return failure(status: 500)
        }
    }

    private func failure(status: Int) -> LocalFleetResponse {
        LocalFleetResponse(statusCode: status, body: Data())
    }
}

// MARK: - Persistence

extension LocalFleetBackend {
    private nonisolated static var defaultStoreURL: URL? {
        try? FileManager.default
            .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent("LocalFleet.json")
    }

    private static func seededState(now: Date) -> LocalFleetState {
        let accounts = LocalFleetSeed.accounts(now: now)
        let messages = accounts.flatMap { LocalFleetSeed.messages(for: $0.user.id, now: now) }
        return LocalFleetState(accounts: accounts, messages: messages)
    }

    private static func loadState(from url: URL?) -> LocalFleetState? {
        guard let url, let data = try? Data(contentsOf: url) else {
            return nil
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try? decoder.decode(LocalFleetState.self, from: data)
    }

    private func persist() {
        guard let storeURL else {
            return
        }

        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601

        do {
            try encoder.encode(state).write(to: storeURL, options: .atomic)
        } catch {
            logger.error("Failed to save local fleet: \(error.localizedDescription, privacy: .public)")
        }
    }
}
