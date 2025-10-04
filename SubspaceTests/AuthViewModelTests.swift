//
//  AuthViewModelTests.swift
//  Subspace
//
//  Created by Clifton Baggerman on 04/10/2025.
//

import Testing
@testable import Subspace

@Suite("Auth ViewModel Tests")
struct AuthViewModelTests {

    @Test("Login with valid credentials succeeds")
    @MainActor
    func loginWithValidCredentials() async throws {
        // Given
        let mockService = MockAuthService()
        let viewModel = AuthViewModel(authService: mockService)

        // When
        await viewModel.login(email: "demo@example.com", password: "password")

        // Then
        #expect(viewModel.isAuthenticated == true)
        #expect(viewModel.currentUser != nil)
        if case .error = viewModel.authState {
            Issue.record("Expected authenticated state, got error")
        }
    }

    @Test("Login with invalid credentials fails")
    @MainActor
    func loginWithInvalidCredentials() async throws {
        // Given
        let mockService = MockAuthService()
        let viewModel = AuthViewModel(authService: mockService)

        // When
        await viewModel.login(email: "wrong@example.com", password: "wrong")

        // Then
        #expect(viewModel.isAuthenticated == false)
        if case .error = viewModel.authState {
            // Expected error state
        } else {
            Issue.record("Expected error state for invalid credentials")
        }
    }

    @Test("Signup with valid data succeeds")
    @MainActor
    func signupWithValidData() async throws {
        // Given
        let mockService = MockAuthService()
        let viewModel = AuthViewModel(authService: mockService)

        // When
        await viewModel.signup(
            name: "Test User",
            email: "test@example.com",
            password: "password123"
        )

        // Then
        #expect(viewModel.isAuthenticated == true)
        #expect(viewModel.currentUser != nil)
    }

    @Test("Logout clears authentication state")
    @MainActor
    func logoutClearsState() async throws {
        // Given
        let mockService = MockAuthService()
        let viewModel = AuthViewModel(authService: mockService)

        // Login first
        await viewModel.login(email: "demo@example.com", password: "password")
        #expect(viewModel.isAuthenticated == true)

        // When
        await viewModel.logout()

        // Then
        #expect(viewModel.isAuthenticated == false)
        #expect(viewModel.authState == .unauthenticated)
    }

    @Test("Check auth status loads from keychain")
    @MainActor
    func checkAuthStatusLoadsFromKeychain() async throws {
        // Given
        let mockService = MockAuthService()
        let viewModel = AuthViewModel(authService: mockService)

        // Login to save token
        await viewModel.login(email: "demo@example.com", password: "password")

        // Create new view model to test persistence
        let newViewModel = AuthViewModel(authService: mockService)

        // When
        await newViewModel.checkAuthStatus()

        // Then
        #expect(newViewModel.isAuthenticated == true)
    }
}
