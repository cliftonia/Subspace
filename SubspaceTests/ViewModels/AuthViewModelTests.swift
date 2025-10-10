//
//  AuthViewModelTests.swift
//  SubspaceTests
//
//  Created by Claude Code on 10/10/2025.
//

import Testing
@testable import Subspace

/// Tests for AuthViewModel authentication flows
@Suite("AuthViewModel Tests")
struct AuthViewModelTests {
    // MARK: - Mock Auth Service

    final class MockAuthService: AuthServiceProtocol {
        var shouldSucceed = true
        var mockUser = User(
            id: "test-123",
            name: "Test User",
            email: "test@example.com",
            avatarURL: nil,
            createdAt: Date()
        )

        func getCurrentUser() async throws -> User? {
            shouldSucceed ? mockUser : nil
        }

        func login(credentials: AuthCredentials) async throws -> AuthResponse {
            guard shouldSucceed else {
                throw AuthServiceError.invalidCredentials
            }
            return AuthResponse(
                user: mockUser,
                tokens: AuthTokens(
                    accessToken: "mock-access",
                    refreshToken: "mock-refresh",
                    expiresAt: Date().addingTimeInterval(3600)
                )
            )
        }

        func signup(name: String, email: String, password: String) async throws -> AuthResponse {
            guard shouldSucceed else {
                throw AuthServiceError.networkError
            }
            return AuthResponse(
                user: mockUser,
                tokens: AuthTokens(
                    accessToken: "mock-access",
                    refreshToken: "mock-refresh",
                    expiresAt: Date().addingTimeInterval(3600)
                )
            )
        }

        func signInWithApple(
            userId: String,
            identityToken: String,
            authorizationCode: String,
            email: String?,
            fullName: PersonNameComponents?
        ) async throws -> AuthResponse {
            try await login(credentials: AuthCredentials(email: "apple@example.com", password: ""))
        }

        func signInWithGoogle(
            userId: String,
            idToken: String,
            accessToken: String,
            email: String,
            fullName: String?
        ) async throws -> AuthResponse {
            try await login(credentials: AuthCredentials(email: "google@example.com", password: ""))
        }

        func logout() async throws {
            // No-op for mock
        }

        func refreshToken() async throws -> AuthTokens {
            AuthTokens(
                accessToken: "mock-refresh-access",
                refreshToken: "mock-refresh-refresh",
                expiresAt: Date().addingTimeInterval(3600)
            )
        }
    }

    // MARK: - Tests

    @Test("Login succeeds with valid credentials")
    func loginSucceeds() async throws {
        // Given
        let mockService = MockAuthService()
        let viewModel = await AuthViewModel(authService: mockService)

        // When
        await viewModel.login(email: "test@example.com", password: "password")

        // Then
        let isAuthenticated = await viewModel.isAuthenticated
        #expect(isAuthenticated == true)

        let currentUser = await viewModel.currentUser
        #expect(currentUser?.email == "test@example.com")
    }

    @Test("Login fails with invalid credentials")
    func loginFails() async throws {
        // Given
        let mockService = MockAuthService()
        mockService.shouldSucceed = false
        let viewModel = await AuthViewModel(authService: mockService)

        // When
        await viewModel.login(email: "wrong@example.com", password: "wrong")

        // Then
        let isAuthenticated = await viewModel.isAuthenticated
        #expect(isAuthenticated == false)

        let authState = await viewModel.authState
        if case .error = authState {
            // Expected error state
        } else {
            Issue.record("Expected error state but got: \(authState)")
        }
    }

    @Test("Signup creates new user")
    func signupSucceeds() async throws {
        // Given
        let mockService = MockAuthService()
        let viewModel = await AuthViewModel(authService: mockService)

        // When
        await viewModel.signup(
            name: "New User",
            email: "new@example.com",
            password: "password123"
        )

        // Then
        let isAuthenticated = await viewModel.isAuthenticated
        #expect(isAuthenticated == true)
    }

    @Test("CheckAuthStatus loads existing user")
    func checkAuthStatusLoadsUser() async throws {
        // Given
        let mockService = MockAuthService()
        let viewModel = await AuthViewModel(authService: mockService)

        // When
        await viewModel.checkAuthStatus()

        // Then
        let isAuthenticated = await viewModel.isAuthenticated
        #expect(isAuthenticated == true)
    }
}
