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
final class APIClient: Sendable {

    // MARK: - Properties

    private let baseURL: URL
    private let urlSession: URLSession
    
    // MARK: - Initialization

    init(
        baseURL: URL = URL(string: "http://localhost:8080/api/v1")!,
        urlSession: URLSession = .shared
    ) {
        self.baseURL = baseURL
        self.urlSession = urlSession
        
        let logger = Logger.app(category: "APIClient")
        logger.debug("APIClient initialized with baseURL: \(baseURL.absoluteString)")
    }

    // MARK: - Generic Request Method

    /// Performs a generic HTTP request
    /// - Parameters:
    ///   - endpoint: The API endpoint path
    ///   - method: HTTP method (GET, POST, etc.)
    ///   - body: Optional request body data
    /// - Returns: Decoded response of type T
    nonisolated func request<T: Decodable & Sendable>(
        _ endpoint: String,
        method: HTTPMethod = .get,
        body: Data? = nil
    ) async throws -> T {
        let url = baseURL.appendingPathComponent(endpoint)
        let logger = Logger.app(category: "APIClient")

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

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

            do {
                let decodedResponse = try await Task.detached {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    return try decoder.decode(T.self, from: data)
                }.value
                return decodedResponse
            } catch {
                logger.error("Decoding failed: \(error.localizedDescription)")
                throw NetworkError.decodingFailed
            }

        } catch let error as NetworkError {
            logger.error("Network error: \(error.localizedDescription)")
            throw error
        } catch {
            logger.error("Request failed: \(error.localizedDescription)")
            throw NetworkError.unknown
        }
    }
    
    /// Simple GET request without retry logic (for debugging)
    nonisolated func simpleRequest<T: Decodable & Sendable>(_ endpoint: String) async throws -> T {
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
    
    // MARK: - Concrete Type Helpers (workaround for MainActor + generic inference issues)

    /// Fetch users list - concrete type version
    nonisolated func fetchUsers() async throws -> ListResponse<User> {
        let url = baseURL.appendingPathComponent("users")
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        let (data, _) = try await urlSession.data(for: request)

        return try await Task.detached {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return try decoder.decode(ListResponse<User>.self, from: data)
        }.value
    }

    /// Fetch single user - concrete type version
    nonisolated func fetchUser(id: String) async throws -> User {
        let url = baseURL.appendingPathComponent("users/\(id)")
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        let (data, _) = try await urlSession.data(for: request)

        return try await Task.detached {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return try decoder.decode(User.self, from: data)
        }.value
    }

    /// Fetch messages - concrete type version
    nonisolated func fetchMessages(userId: String) async throws -> [FreshMessageResponse] {
        let url = baseURL.appendingPathComponent("users/\(userId)/messages")
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        let (data, _) = try await urlSession.data(for: request)

        return try await Task.detached {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return try decoder.decode([FreshMessageResponse].self, from: data)
        }.value
    }

    // MARK: - Static Instance

    /// Current APIClient configuration based on build settings
    static let current = APIClient()
}

// MARK: - HTTP Method

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}
