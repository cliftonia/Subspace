//
//  AuthIntegrationTests.swift
//  SubspaceTests
//
//  Integration tests for authentication flows against live backend
//
//

import Foundation
import Security
import Testing
@testable import Subspace

/// Integration tests for authentication flows
///
/// These tests run against the actual backend API (localhost:8080)
/// Make sure the backend is running before executing these tests
@Suite("Auth Integration Tests")
struct AuthIntegrationTests {
    // MARK: - Properties

    let baseURL = URL(string: "http://localhost:8080/api/v1")!

    // MARK: - Helper Methods

    /// Creates a test API client
    func createAPIClient() -> APIClient {
        APIClient(baseURL: baseURL)
    }

    /// Creates a test auth service
    func createAuthService() -> AuthService {
        let apiClient = createAPIClient()
        let keychainService = MockKeychainService()
        return AuthService(apiClient: apiClient, keychainService: keychainService)
    }

    /// Creates auth service with shared mock keychain for testing
    func createAuthServiceWithMockKeychain() -> (AuthService, MockKeychainService) {
        let apiClient = createAPIClient()
        let keychainService = MockKeychainService()
        let authService = AuthService(apiClient: apiClient, keychainService: keychainService)
        return (authService, keychainService)
    }

    /// Generates a unique email for testing
    func generateTestEmail() -> String {
        "test+\(UUID().uuidString)@example.com"
    }

    // MARK: - Registration Tests

    @Test("User can register with valid credentials")
    func userRegistration() async throws {
        // Given
        let authService = createAuthService()
        let email = generateTestEmail()
        let password = "TestPassword123!"
        let name = "Test User"

        // When
        let response = try await authService.signup(
            name: name,
            email: email,
            password: password
        )

        // Then
        #expect(response.user.email == email)
        #expect(response.user.name == name)
        #expect(!response.accessToken.isEmpty)
        #expect(!response.refreshToken.isEmpty)
        #expect(response.accessToken != response.refreshToken)
    }

    @Test("Registration fails with duplicate email")
    func duplicateEmailRegistration() async throws {
        // Given
        let authService = createAuthService()
        let email = generateTestEmail()
        let password = "TestPassword123!"

        // Create first user
        _ = try await authService.signup(
            name: "First User",
            email: email,
            password: password
        )

        // When/Then - Try to create duplicate
        do {
            _ = try await authService.signup(
                name: "Second User",
                email: email,
                password: password
            )
            Issue.record("Expected registration to fail with duplicate email")
        } catch {
            // Expected to throw error
            #expect(error is NetworkError)
        }
    }

    @Test("Registration fails with weak password")
    func weakPasswordRegistration() async throws {
        // Given
        let authService = createAuthService()
        let email = generateTestEmail()
        let weakPassword = "123" // Less than 8 characters

        // When/Then
        do {
            _ = try await authService.signup(
                name: "Test User",
                email: email,
                password: weakPassword
            )
            Issue.record("Expected registration to fail with weak password")
        } catch {
            // Expected to throw error
            #expect(error is NetworkError)
        }
    }

    // MARK: - Login Tests

    @Test("User can login with valid credentials")
    func userLogin() async throws {
        // Given
        let authService = createAuthService()
        let email = generateTestEmail()
        let password = "TestPassword123!"

        // Create user first
        _ = try await authService.signup(
            name: "Test User",
            email: email,
            password: password
        )

        // When
        let credentials = AuthCredentials(email: email, password: password)
        let response = try await authService.login(credentials: credentials)

        // Then
        #expect(response.user.email == email)
        #expect(!response.accessToken.isEmpty)
        #expect(!response.refreshToken.isEmpty)
    }

    @Test("Login fails with invalid password")
    func invalidPasswordLogin() async throws {
        // Given
        let authService = createAuthService()
        let email = generateTestEmail()
        let correctPassword = "TestPassword123!"
        let wrongPassword = "WrongPassword123!"

        // Create user first
        _ = try await authService.signup(
            name: "Test User",
            email: email,
            password: correctPassword
        )

        // When/Then - Try to login with wrong password
        do {
            let credentials = AuthCredentials(email: email, password: wrongPassword)
            _ = try await authService.login(credentials: credentials)
            Issue.record("Expected login to fail with wrong password")
        } catch {
            // Expected to throw error
            #expect(error is NetworkError)
        }
    }

    @Test("Login fails with non-existent email")
    func nonExistentEmailLogin() async throws {
        // Given
        let authService = createAuthService()
        let email = "nonexistent@example.com"
        let password = "TestPassword123!"

        // When/Then
        do {
            let credentials = AuthCredentials(email: email, password: password)
            _ = try await authService.login(credentials: credentials)
            Issue.record("Expected login to fail with non-existent email")
        } catch {
            // Expected to throw error
            #expect(error is NetworkError)
        }
    }

    // MARK: - Token Refresh Tests

    @Test("User can refresh access token")
    func tokenRefresh() async throws {
        // Given
        let authService = createAuthService()
        let email = generateTestEmail()
        let password = "TestPassword123!"

        // Create user and login
        _ = try await authService.signup(
            name: "Test User",
            email: email,
            password: password
        )

        // Get initial tokens
        let initialResponse = try await authService.login(
            credentials: AuthCredentials(email: email, password: password)
        )
        let initialAccessToken = initialResponse.accessToken
        let initialRefreshToken = initialResponse.refreshToken

        // When - Refresh token
        let newTokens = try await authService.refreshToken()

        // Then
        #expect(!newTokens.accessToken.isEmpty)
        #expect(!newTokens.refreshToken.isEmpty)
        #expect(newTokens.accessToken != initialAccessToken, "New access token should be different")
        #expect(newTokens.refreshToken != initialRefreshToken, "New refresh token should be different (token rotation)")
    }

    @Test("Refresh fails with invalid token")
    func invalidTokenRefresh() async throws {
        // Given
        let (authService, mockKeychainService) = createAuthServiceWithMockKeychain()

        // Set invalid tokens
        let invalidTokens = AuthTokens(
            accessToken: "invalid-access-token",
            refreshToken: "invalid-refresh-token",
            expiresAt: Date().addingTimeInterval(3600)
        )
        try mockKeychainService.saveTokens(invalidTokens)

        // When/Then
        do {
            _ = try await authService.refreshToken()
            Issue.record("Expected refresh to fail with invalid token")
        } catch {
            // Expected to throw error
            #expect(error is NetworkError)
        }
    }

    @Test("Old refresh token cannot be reused after refresh")
    func refreshTokenRotation() async throws {
        // Given
        let (authService, mockKeychainService) = createAuthServiceWithMockKeychain()
        let email = generateTestEmail()
        let password = "TestPassword123!"

        // Create user and login
        _ = try await authService.signup(
            name: "Test User",
            email: email,
            password: password
        )

        let initialResponse = try await authService.login(
            credentials: AuthCredentials(email: email, password: password)
        )
        let oldRefreshToken = initialResponse.refreshToken

        // Refresh once to get new tokens
        _ = try await authService.refreshToken()

        // When/Then - Try to use old refresh token
        let oldTokens = AuthTokens(
            accessToken: "dummy",
            refreshToken: oldRefreshToken,
            expiresAt: Date().addingTimeInterval(3600)
        )
        try mockKeychainService.saveTokens(oldTokens)

        do {
            _ = try await authService.refreshToken()
            Issue.record("Expected old refresh token to be rejected")
        } catch {
            // Expected - old token should be revoked
            #expect(error is NetworkError)
        }
    }

    // MARK: - Get Current User Tests

    @Test("Can retrieve current user with valid token")
    func getCurrentUser() async throws {
        // Given
        let authService = createAuthService()
        let email = generateTestEmail()
        let password = "TestPassword123!"
        let name = "Test User"

        // Create and login user
        _ = try await authService.signup(
            name: name,
            email: email,
            password: password
        )

        // When
        let user = try await authService.getCurrentUser()

        // Then
        #expect(user != nil)
        #expect(user?.email == email)
        #expect(user?.name == name)
    }

    // MARK: - Apple Sign In Tests

    @Test("Apple Sign In works with mock token")
    func appleSignInMock() async throws {
        // Given
        let authService = createAuthService()
        let email = generateTestEmail()

        var fullName = PersonNameComponents()
        fullName.givenName = "John"
        fullName.familyName = "Appleseed"

        // When - Use mock token for simulator testing
        let response = try await authService.signInWithApple(
            userId: "apple-\(UUID().uuidString)",
            identityToken: "mock-id-token",
            authorizationCode: "mock-auth-code",
            email: email,
            fullName: fullName
        )

        // Then
        #expect(response.user.email == email)
        #expect(!response.accessToken.isEmpty)
        #expect(!response.refreshToken.isEmpty)
    }

    // MARK: - Google Sign In Tests

    @Test("Google Sign In works with mock token")
    func googleSignInMock() async throws {
        // Given
        let authService = createAuthService()
        let email = generateTestEmail()
        let fullName = "John Doe"

        // When - Use mock token for simulator testing
        let response = try await authService.signInWithGoogle(
            userId: "google-\(UUID().uuidString)",
            idToken: "mock-id-token",
            accessToken: "mock-access-token",
            email: email,
            fullName: fullName
        )

        // Then
        #expect(response.user.email == email)
        #expect(!response.accessToken.isEmpty)
        #expect(!response.refreshToken.isEmpty)
    }
}

// MARK: - Mock Keychain Service

/// Mock keychain service for testing
final class MockKeychainService: KeychainServiceProtocol, @unchecked Sendable {
    private var storage: AuthTokens?

    func saveTokens(_ tokens: AuthTokens) throws {
        storage = tokens
    }

    func getTokens() throws -> AuthTokens {
        guard let tokens = storage else {
            throw KeychainError.readFailed(status: errSecItemNotFound)
        }
        return tokens
    }

    func deleteTokens() throws {
        storage = nil
    }
}
