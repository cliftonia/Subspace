//
//  AuthViewModel.swift
//  Subspace
//
//  Created by Clifton Baggerman on 04/10/2025.
//

import Observation
import os
import SwiftUI

// MARK: - Auth View Model

/// ViewModel managing authentication state and operations
@MainActor
@Observable
final class AuthViewModel {
    // MARK: - Properties

    private(set) var authState: AuthState = .loading
    private(set) var isProcessing = false

    // MARK: - Private Properties

    private let logger = Logger.app(category: "AuthViewModel")
    private let authService: AuthServiceProtocol
    private let appleAuthService: AppleAuthServiceProtocol
    private let googleAuthService: GoogleAuthServiceProtocol

    // MARK: - Computed Properties

    /// Indicates whether the user is currently authenticated
    var isAuthenticated: Bool {
        if case .authenticated = authState {
            return true
        }
        return false
    }

    /// Returns the currently authenticated user if available
    var currentUser: User? {
        if case .authenticated(let user) = authState {
            return user
        }
        return nil
    }

    // MARK: - Initialization

    /// Initializes the auth view model with all required authentication services
    /// - Parameters:
    ///   - authService: Main authentication service
    ///   - appleAuthService: Service for Apple Sign In
    ///   - googleAuthService: Service for Google Sign In
    init(
        authService: AuthServiceProtocol,
        appleAuthService: AppleAuthServiceProtocol,
        googleAuthService: GoogleAuthServiceProtocol
    ) {
        self.authService = authService
        self.appleAuthService = appleAuthService
        self.googleAuthService = googleAuthService
    }

    /// Convenience initializer with default authentication services
    /// - Parameter authService: Main authentication service
    convenience init(authService: AuthServiceProtocol) {
        self.init(
            authService: authService,
            appleAuthService: AppleAuthService(),
            googleAuthService: GoogleAuthService()
        )
    }

    // MARK: - Public Methods

    /// Checks current authentication status on app launch
    func checkAuthStatus() async {
        logger.info("Checking authentication status")
        authState = .loading

        do {
            if let user = try await authService.getCurrentUser() {
                authState = .authenticated(user)
                logger.info("User is authenticated: \\(user.id)")
                HapticFeedback.success()
            } else {
                authState = .unauthenticated
                logger.info("User is not authenticated")
            }
        } catch {
            logger.error("Failed to check auth status: \\(error.localizedDescription)")
            authState = .unauthenticated
        }
    }

    /// Authenticates user with email and password credentials
    /// - Parameters:
    ///   - email: User's email address
    ///   - password: User's password
    func login(email: String, password: String) async {
        logger.info("Attempting login for email: \\(email)")

        isProcessing = true
        authState = .loading

        do {
            let credentials = AuthCredentials(email: email, password: password)
            let response = try await authService.login(credentials: credentials)

            authState = .authenticated(response.user)
            logger.info("Login successful for user: \\(response.user.id)")
            HapticFeedback.success()
        } catch {
            logger.error("Login failed: \\(error.localizedDescription)")
            authState = .error(error.localizedDescription)
            HapticFeedback.error()
        }

        isProcessing = false
    }

    /// Creates a new user account with provided credentials
    /// - Parameters:
    ///   - name: User's full name
    ///   - email: User's email address
    ///   - password: Desired password
    func signup(name: String, email: String, password: String) async {
        logger.info("Attempting signup for email: \\(email)")

        isProcessing = true
        authState = .loading

        do {
            let response = try await authService.signup(
                name: name,
                email: email,
                password: password
            )

            authState = .authenticated(response.user)
            logger.info("Signup successful for user: \\(response.user.id)")
            HapticFeedback.success()
        } catch {
            logger.error("Signup failed: \\(error.localizedDescription)")
            authState = .error(error.localizedDescription)
            HapticFeedback.error()
        }

        isProcessing = false
    }

    /// Authenticates user using Apple Sign In
    func signInWithApple() async {
        logger.info("Attempting Sign in with Apple")

        isProcessing = true
        authState = .loading

        do {
            // For development/simulator: Use mock Apple sign-in directly
            #if targetEnvironment(simulator)
            logger.info("Using mock Apple Sign-In for simulator")
            let response = try await authService.signInWithApple(
                userId: "simulator-apple-user",
                identityToken: "mock-token",
                authorizationCode: "mock-code",
                email: "apple@example.com",
                fullName: PersonNameComponents(givenName: "Apple", familyName: "User")
            )
            authState = .authenticated(response.user)
            logger.info("Mock Apple sign in successful")
            #else
            // For real device: Use actual Apple Sign-In
            let appleResult = try await appleAuthService.signIn()
            let response = try await authService.signInWithApple(
                userId: appleResult.userId,
                identityToken: appleResult.identityToken,
                authorizationCode: appleResult.authorizationCode,
                email: appleResult.email,
                fullName: appleResult.fullName
            )
            authState = .authenticated(response.user)
            logger.info("Apple sign in successful for user: \\(response.user.id)")
            #endif

            HapticFeedback.success()
        } catch {
            logger.error("Apple sign in failed: \\(error.localizedDescription)")
            authState = .error(error.localizedDescription)
            HapticFeedback.error()
        }

        isProcessing = false
    }

    /// Authenticates user using Google Sign In
    func signInWithGoogle() async {
        logger.info("Attempting Sign in with Google")

        isProcessing = true
        authState = .loading

        do {
            // For development/simulator: Use mock Google sign-in directly
            #if targetEnvironment(simulator)
            logger.info("Using mock Google Sign-In for simulator")
            let response = try await authService.signInWithGoogle(
                userId: "simulator-google-user",
                idToken: "mock-id-token",
                accessToken: "mock-access-token",
                email: "google@example.com",
                fullName: "Google User"
            )
            authState = .authenticated(response.user)
            logger.info("Mock Google sign in successful")
            #else
            // For real device: Use actual Google Sign-In
            let googleResult = try await googleAuthService.signIn()
            let response = try await authService.signInWithGoogle(
                userId: googleResult.userId,
                idToken: googleResult.idToken,
                accessToken: googleResult.accessToken,
                email: googleResult.email,
                fullName: googleResult.fullName
            )
            authState = .authenticated(response.user)
            logger.info("Google sign in successful for user: \\(response.user.id)")
            #endif

            HapticFeedback.success()
        } catch {
            logger.error("Google sign in failed: \\(error.localizedDescription)")
            authState = .error(error.localizedDescription)
            HapticFeedback.error()
        }

        isProcessing = false
    }

    /// Logs out the currently authenticated user
    func logout() async {
        logger.info("Logging out user")

        isProcessing = true

        do {
            try await authService.logout()
            authState = .unauthenticated
            logger.info("Logout successful")
            HapticFeedback.success()
        } catch {
            logger.error("Logout failed: \\(error.localizedDescription)")
            authState = .error(error.localizedDescription)
            HapticFeedback.error()
        }

        isProcessing = false
    }

    /// Clears any error state and returns to unauthenticated state
    func clearError() {
        if case .error = authState {
            authState = .unauthenticated
        }
    }
}
