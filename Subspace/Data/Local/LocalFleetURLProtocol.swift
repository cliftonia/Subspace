//
//  LocalFleetURLProtocol.swift
//  Subspace
//
//  Created by Clifton Baggerman on 30/10/2026.
//

import Foundation

/// Serves API requests from the local fleet, so `APIClient` runs the same code with or without a server
nonisolated final class LocalFleetURLProtocol: URLProtocol, @unchecked Sendable {
    // MARK: - URLProtocol

    override class func canInit(with request: URLRequest) -> Bool {
        true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }

    override func startLoading() {
        let localRequest = LocalFleetRequest(urlRequest: request)

        Task {
            let response = await LocalFleetBackend.shared.respond(to: localRequest)
            finish(with: response)
        }
    }

    override func stopLoading() {}

    // MARK: - Private Methods

    private func finish(with response: LocalFleetResponse) {
        guard let url = request.url,
              let httpResponse = HTTPURLResponse(
                  url: url,
                  statusCode: response.statusCode,
                  httpVersion: "HTTP/1.1",
                  headerFields: ["Content-Type": "application/json"]
              ) else {
            client?.urlProtocol(self, didFailWithError: URLError(.badServerResponse))
            return
        }

        client?.urlProtocol(self, didReceive: httpResponse, cacheStoragePolicy: .notAllowed)
        client?.urlProtocol(self, didLoad: response.body)
        client?.urlProtocolDidFinishLoading(self)
    }
}

// MARK: - Request Translation

nonisolated extension LocalFleetRequest {
    init(urlRequest: URLRequest) {
        let authorization = urlRequest.value(forHTTPHeaderField: "Authorization")

        self.init(
            method: urlRequest.httpMethod ?? "GET",
            pathComponents: urlRequest.url?.pathComponents.filter { $0 != "/" } ?? [],
            bearerToken: authorization?.replacingOccurrences(of: "Bearer ", with: ""),
            body: urlRequest.httpBody ?? urlRequest.httpBodyStream.map(Self.readAll)
        )
    }

    /// URLSession moves request bodies into a stream before they reach a URLProtocol
    private static func readAll(_ stream: InputStream) -> Data {
        var data = Data()
        var buffer = [UInt8](repeating: 0, count: 4096)

        stream.open()
        defer { stream.close() }

        while stream.hasBytesAvailable {
            let bytesRead = stream.read(&buffer, maxLength: buffer.count)
            guard bytesRead > 0 else {
                break
            }
            data.append(buffer, count: bytesRead)
        }

        return data
    }
}

// MARK: - Session

nonisolated extension URLSession {
    /// A session whose every request is answered by the local fleet
    static let localFleet: URLSession = {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [LocalFleetURLProtocol.self]
        return URLSession(configuration: configuration)
    }()
}
