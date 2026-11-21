//
//  APIClient.swift
//  Subspace
//
//  Created by Clifton Baggerman on 03/10/2025.
//

import Foundation
import os

// MARK: - API Client

/// Main API client for backend communication
nonisolated final class APIClient: Sendable {
    // MARK: - Properties

    private let baseURL: URL
    private let urlSession: URLSession
    private let keychainService: KeychainServiceProtocol

    // MARK: - Initialization

    init(
        baseURL: URL,
        urlSession: URLSession = .shared,
        keychainService: KeychainServiceProtocol = KeychainService()
    ) {
        self.baseURL = baseURL
        self.urlSession = urlSession
        self.keychainService = keychainService

        let logger = Logger.app(category: "APIClient")
        logger.debug("APIClient initialized with baseURL: \(baseURL.absoluteString)")
    }

    // MARK: - Generic Request Method

    /// Performs a generic HTTP request
    /// - Parameters:
    ///   - endpoint: The API endpoint path
    ///   - method: HTTP method (GET, POST, etc.)
    ///   - body: Optional request body data
    ///   - includeAuth: Whether to include Authorization header (default: true)
    /// - Returns: Decoded response of type T
    func request<T: Decodable & Sendable>(
        _ endpoint: String,
        method: HTTPMethod = .get,
        body: Data? = nil,
        includeAuth: Bool = true
    ) async throws -> T {
        let url = baseURL.appendingPathComponent(endpoint)
        let logger = Logger.app(category: "APIClient")

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        // Add Authorization header if required and token is available
        if includeAuth, let tokens = try? keychainService.getTokens(), !tokens.isExpired {
            request.setValue("Bearer \(tokens.accessToken)", forHTTPHeaderField: "Authorization")
        }

        if let body = body {
            request.httpBody = body
        }

        logger.debug("\(method.rawValue) \(url.absoluteString)")

        do {
            let (data, response) = try await urlSession.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }

            logger.debug("Response status: \(httpResponse.statusCode)")

            guard (200...299).contains(httpResponse.statusCode) else {
                throw NetworkError.serverError(code: httpResponse.statusCode)
            }

            return try await decodeResponse(from: data)
        } catch let error as NetworkError {
            logger.error("Network error: \(error.localizedDescription)")
            throw error
        } catch let error as URLError where error.code == .cancelled {
            throw CancellationError()
        } catch {
            logger.error("Request failed: \(error.localizedDescription)")
            throw NetworkError.unknown
        }
    }

    /// Decodes a response body away from the calling context
    private func decodeResponse<T: Decodable & Sendable>(from data: Data) async throws -> T {
        do {
            return try await Task.detached {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                return try decoder.decode(T.self, from: data)
            }.value
        } catch {
            Logger.app(category: "APIClient").error("Decoding failed: \(error.localizedDescription)")
            throw NetworkError.decodingFailed
        }
    }

    /// Simple GET request without retry logic (for debugging)
    func simpleRequest<T: Decodable & Sendable>(_ endpoint: String) async throws -> T {
        try await request(endpoint, method: .get, body: nil)
    }

    /// Performs a request with retry logic
    /// - Parameters:
    ///   - endpoint: The API endpoint path
    ///   - method: HTTP method (GET, POST, etc.)
    ///   - body: Optional request body data
    ///   - retryPolicy: The retry policy to use
    /// - Returns: Decoded response of type T
    func requestWithRetry<T: Decodable & Sendable>(
        _ endpoint: String,
        method: HTTPMethod = .get,
        body: Data? = nil,
        retryPolicy: RetryPolicy = .standard
    ) async throws -> T {
        var lastError: Error?

        for attempt in 1...retryPolicy.maxAttempts {
            do {
                return try await request(endpoint, method: method, body: body)
            } catch is CancellationError {
                throw CancellationError()
            } catch {
                lastError = error

                if attempt < retryPolicy.maxAttempts {
                    let delay = retryPolicy.baseDelay * pow(retryPolicy.multiplier, Double(attempt - 1))
                    let clampedDelay = min(delay, retryPolicy.maxDelay)
                    try await Task.sleep(for: .seconds(clampedDelay))
                }
            }
        }

        throw lastError ?? NetworkError.unknown
    }

    // MARK: - Concrete Type Helpers

    /// Fetch users list - concrete type version
    func fetchUsers() async throws -> ListResponse<User> {
        try await request("users")
    }

    /// Fetch single user - concrete type version
    func fetchUser(id: String) async throws -> User {
        try await request("users/\(id)")
    }

    /// Fetch messages - concrete type version
    func fetchMessages(userId: String) async throws -> [FreshMessageResponse] {
        let response: FreshListResponse<FreshMessageResponse> = try await request("users/\(userId)/messages")
        return response.data
    }

    // MARK: - Static Instance

    /// Current APIClient configuration based on build settings
    static let current = AppConfiguration.usesLocalFleet
        ? APIClient(baseURL: AppConfiguration.localFleetURL, urlSession: .localFleet)
        : APIClient(baseURL: AppConfiguration.apiBaseURL)
}

// MARK: - HTTP Method

nonisolated enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}
