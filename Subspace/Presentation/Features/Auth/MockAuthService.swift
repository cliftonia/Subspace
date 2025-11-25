//
//  MockAuthService.swift
//  Subspace
//
//  Created by Clifton Baggerman on 04/10/2025.
//

import Foundation
import os

// MARK: - Mock Auth Service

/// Mock authentication service for development and testing
/// Simulates backend authentication without requiring a real server
final class MockAuthService: AuthServiceProtocol, Sendable {
    // MARK: - Properties

    private let logger = Logger.app(category: "MockAuthService")
    private let keychainService: KeychainServiceProtocol

    // Mock users database
    private let mockUsers: [String: (name: String, password: String)] = [
        "demo@example.com": (name: "Demo User", password: "password"),
        "picard@starfleet.com": (name: "Jean-Luc Picard", password: "engage"),
        "riker@starfleet.com": (name: "William Riker", password: "number1")
    ]

    // MARK: - Initialization

    /// Initializes the mock authentication service
    /// - Parameter keychainService: Service for secure token storage
    init(keychainService: KeychainServiceProtocol = KeychainService()) {
        self.keychainService = keychainService
    }

    // MARK: - Public Methods

    /// Retrieves the currently authenticated user from stored tokens
    /// - Returns: User if valid tokens exist, nil otherwise
    func getCurrentUser() async throws -> User? {
        // Check if we have valid tokens
        guard let tokens = try? keychainService.getTokens(),
              !tokens.isExpired else {
            return nil
        }

        // Return mock user
        return User(
            id: "mock-user-123",
            name: "Demo User",
            email: "demo@example.com",
            avatarURL: nil,
            createdAt: Date()
        )
    }

    /// Authenticates user with email and password against mock user database
    /// - Parameter credentials: User's email and password
    /// - Returns: Authentication response with user data and tokens
    /// - Throws: AuthServiceError.invalidCredentials if credentials don't match
    func login(credentials: AuthCredentials) async throws -> AuthResponse {
        logger.info("Mock login for: \(credentials.email)")

        // Simulate network delay
        try await Task.sleep(for: .seconds(1))

        // Check credentials
        guard let mockUser = mockUsers[credentials.email],
              mockUser.password == credentials.password else {
            logger.error("Invalid credentials")
            throw AuthServiceError.invalidCredentials
        }

        // Create mock user and tokens
        let user = User(
            id: "mock-user-\(UUID().uuidString.prefix(8))",
            name: mockUser.name,
            email: credentials.email,
            avatarURL: nil,
            createdAt: Date()
        )

        let token = "mock-jwt-token-\(UUID().uuidString)"

        // Create AuthTokens and store them
        let tokens = AuthTokens(
            accessToken: token,
            refreshToken: token,
            expiresAt: Date().addingTimeInterval(3600) // 1 hour
        )
        try keychainService.saveTokens(tokens)

        logger.info("Mock login successful")
        return AuthResponse(user: user, accessToken: token, refreshToken: token)
    }

    /// Creates a new user account with provided credentials
    /// - Parameters:
    ///   - name: User's full name
    ///   - email: User's email address
    ///   - password: Desired password
    /// - Returns: Authentication response with user data and tokens
    /// - Throws: Error if user already exists in mock database
    func signup(name: String, email: String, password: String) async throws -> AuthResponse {
        logger.info("Mock signup for: \(email)")

        // Simulate network delay
        try await Task.sleep(for: .seconds(1))

        // Check if user already exists
        if mockUsers[email] != nil {
            logger.error("User already exists")
            throw NSError(domain: "MockAuth", code: 409, userInfo: [
                NSLocalizedDescriptionKey: "User already exists"
            ])
        }

        // Create mock user and tokens
        let user = User(
            id: "mock-user-\(UUID().uuidString.prefix(8))",
            name: name,
            email: email,
            avatarURL: nil,
            createdAt: Date()
        )

        let token = "mock-jwt-token-\(UUID().uuidString)"

        // Create AuthTokens and store them
        let tokens = AuthTokens(
            accessToken: token,
            refreshToken: token,
            expiresAt: Date().addingTimeInterval(3600)
        )
        try keychainService.saveTokens(tokens)

        logger.info("Mock signup successful")
        return AuthResponse(user: user, accessToken: token, refreshToken: token)
    }

    /// Authenticates user using Apple Sign In credentials
    /// - Parameter credentials: Apple sign in credentials containing user info and tokens
    /// - Returns: Authentication response with user data and tokens
    func signInWithApple(credentials: AppleSignInCredentials) async throws -> AuthResponse {
        logger.info("Mock Apple sign in")

        // Simulate network delay
        try await Task.sleep(for: .seconds(1))

        let name = [credentials.fullName?.givenName, credentials.fullName?.familyName]
            .compactMap { $0 }
            .joined(separator: " ")

        let user = User(
            id: "mock-apple-\(credentials.userId.prefix(8))",
            name: name.isEmpty ? "Apple User" : name,
            email: credentials.email ?? "apple-user@privaterelay.appleid.com",
            avatarURL: nil,
            createdAt: Date()
        )

        let token = "mock-jwt-token-\(UUID().uuidString)"

        // Create AuthTokens and store them
        let tokens = AuthTokens(
            accessToken: token,
            refreshToken: token,
            expiresAt: Date().addingTimeInterval(3600)
        )
        try keychainService.saveTokens(tokens)

        logger.info("Mock Apple sign in successful")
        return AuthResponse(user: user, accessToken: token, refreshToken: token)
    }

    /// Authenticates user using Google Sign In credentials
    /// - Parameter credentials: Google sign in credentials containing user info and tokens
    /// - Returns: Authentication response with user data and tokens
    func signInWithGoogle(credentials: GoogleSignInCredentials) async throws -> AuthResponse {
        logger.info("Mock Google sign in")

        // Simulate network delay
        try await Task.sleep(for: .seconds(1))

        let user = User(
            id: "mock-google-\(credentials.userId.prefix(8))",
            name: credentials.fullName ?? "Google User",
            email: credentials.email,
            avatarURL: nil,
            createdAt: Date()
        )

        let token = "mock-jwt-token-\(UUID().uuidString)"

        // Create AuthTokens and store them
        let tokens = AuthTokens(
            accessToken: token,
            refreshToken: token,
            expiresAt: Date().addingTimeInterval(3600)
        )
        try keychainService.saveTokens(tokens)

        logger.info("Mock Google sign in successful")
        return AuthResponse(user: user, accessToken: token, refreshToken: token)
    }

    /// Logs out the current user by clearing stored tokens
    /// - Throws: Error if token deletion fails
    func logout() async throws {
        logger.info("Mock logout")
        try keychainService.deleteTokens()
    }

    /// Refreshes the access token using stored refresh token
    /// - Returns: New authentication tokens
    /// - Throws: AuthServiceError.noTokensFound if no tokens exist
    func refreshToken() async throws -> AuthTokens {
        logger.info("Mock token refresh")

        guard let currentTokens = try? keychainService.getTokens() else {
            throw AuthServiceError.noTokensFound
        }

        // Create new tokens
        let tokens = AuthTokens(
            accessToken: "mock-access-token-\(UUID().uuidString)",
            refreshToken: currentTokens.refreshToken,
            expiresAt: Date().addingTimeInterval(3600)
        )

        try keychainService.saveTokens(tokens)
        return tokens
    }
}

// MARK: - Demo Credentials

extension MockAuthService {
    /// Demo credential model
    struct DemoCredential {
        let email: String
        let password: String
        let name: String
    }

    /// Demo credentials for easy testing
    static let demoCredentials: [DemoCredential] = [
        DemoCredential(email: "demo@example.com", password: "password", name: "Demo User"),
        DemoCredential(email: "picard@starfleet.com", password: "engage", name: "Jean-Luc Picard"),
        DemoCredential(email: "riker@starfleet.com", password: "number1", name: "William Riker")
    ]
}
