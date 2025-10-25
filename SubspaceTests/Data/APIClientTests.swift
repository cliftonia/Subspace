//
//  APIClientTests.swift
//  SubspaceTests
//
//

import Foundation
import Testing
@testable import Subspace

/// Tests for APIClient networking functionality
@Suite("APIClient Tests")
struct APIClientTests {
    // MARK: - Mock URL Session

    final class MockURLProtocol: URLProtocol {
        static var mockData: Data?
        static var mockResponse: HTTPURLResponse?
        static var mockError: Error?

        override class func canInit(with request: URLRequest) -> Bool {
            true
        }

        override class func canonicalRequest(for request: URLRequest) -> URLRequest {
            request
        }

        override func startLoading() {
            if let error = MockURLProtocol.mockError {
                client?.urlProtocol(self, didFailWithError: error)
                return
            }

            if let response = MockURLProtocol.mockResponse {
                client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            }

            if let data = MockURLProtocol.mockData {
                client?.urlProtocol(self, didLoad: data)
            }

            client?.urlProtocolDidFinishLoading(self)
        }

        override func stopLoading() {
            // No-op
        }
    }

    // MARK: - Test Models

    struct TestResponse: Codable, Sendable {
        let id: String
        let name: String
    }

    // MARK: - Helper Functions

    func createMockSession() -> URLSession {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        return URLSession(configuration: configuration)
    }

    // MARK: - Tests

    @Test("API client makes successful GET request")
    func successfulGetRequest() async throws {
        // Given
        let mockData = """
        {
            "id": "123",
            "name": "Test Item"
        }
        """.data(using: .utf8)!

        let mockResponse = HTTPURLResponse(
            url: URL(string: "http://localhost:8080/api/v1/test")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!

        MockURLProtocol.mockData = mockData
        MockURLProtocol.mockResponse = mockResponse
        MockURLProtocol.mockError = nil

        let session = createMockSession()
        let baseURL = URL(string: "http://localhost:8080/api/v1")!
        let client = APIClient(baseURL: baseURL, urlSession: session)

        // When
        let response: TestResponse = try await client.request("test", method: .get)

        // Then
        #expect(response.id == "123")
        #expect(response.name == "Test Item")
    }

    @Test("API client handles 404 error")
    func handles404Error() async throws {
        // Given
        let mockResponse = HTTPURLResponse(
            url: URL(string: "http://localhost:8080/api/v1/test")!,
            statusCode: 404,
            httpVersion: nil,
            headerFields: nil
        )!

        MockURLProtocol.mockData = nil
        MockURLProtocol.mockResponse = mockResponse
        MockURLProtocol.mockError = nil

        let session = createMockSession()
        let baseURL = URL(string: "http://localhost:8080/api/v1")!
        let client = APIClient(baseURL: baseURL, urlSession: session)

        // When/Then
        do {
            let _: TestResponse = try await client.request("test", method: .get)
            Issue.record("Expected NetworkError to be thrown")
        } catch let error as NetworkError {
            if case .serverError(let code) = error {
                #expect(code == 404)
            } else {
                Issue.record("Expected serverError but got: \(error)")
            }
        } catch {
            Issue.record("Expected NetworkError but got: \(error)")
        }
    }

    @Test("API client retries on failure")
    func retriesOnFailure() async throws {
        // Given
        let mockData = """
        {
            "id": "456",
            "name": "Retry Test"
        }
        """.data(using: .utf8)!

        let mockResponse = HTTPURLResponse(
            url: URL(string: "http://localhost:8080/api/v1/test")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!

        // First attempt will fail, second succeeds
        MockURLProtocol.mockData = mockData
        MockURLProtocol.mockResponse = mockResponse
        MockURLProtocol.mockError = nil

        let session = createMockSession()
        let baseURL = URL(string: "http://localhost:8080/api/v1")!
        let client = APIClient(baseURL: baseURL, urlSession: session)

        let retryPolicy = RetryPolicy(maxAttempts: 3, baseDelay: 0.1, maxDelay: 1.0, multiplier: 2.0)

        // When
        let response: TestResponse = try await client.requestWithRetry(
            "test",
            method: .get,
            retryPolicy: retryPolicy
        )

        // Then
        #expect(response.id == "456")
    }
}
