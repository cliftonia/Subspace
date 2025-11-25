//
//  AuthService.swift
//  Subspace
//
//  Created by Clifton Baggerman on 04/10/2025.
//

import Foundation
import os

// MARK: - Social Sign In Credentials

/// Credentials for Apple Sign In
struct AppleSignInCredentials: Sendable {
    let userId: String
    let identityToken: String
    let authorizationCode: String
    let email: String?
    let fullName: PersonNameComponents?
}

/// Credentials for Google Sign In
struct GoogleSignInCredentials: Sendable {
    let userId: String
    let idToken: String
    let accessToken: String
    let email: String
    let fullName: String?
}

// MARK: - Auth Service Protocol

protocol AuthServiceProtocol: Sendable {
    func getCurrentUser() async throws -> User?
    func login(credentials: AuthCredentials) async throws -> AuthResponse
    func signup(name: String, email: String, password: String) async throws -> AuthResponse
    func signInWithApple(credentials: AppleSignInCredentials) async throws -> AuthResponse
    func signInWithGoogle(credentials: GoogleSignInCredentials) async throws -> AuthResponse
    func logout() async throws
    func refreshToken() async throws -> AuthTokens
}

// MARK: - Auth Service

final class AuthService: AuthServiceProtocol, Sendable {
    // MARK: - Properties

    private let logger = Logger.app(category: "AuthService")
    private let apiClient: APIClient
    private let keychainService: KeychainServiceProtocol

    // MARK: - Initialization

    /// Initializes the authentication service
    /// - Parameters:
    ///   - apiClient: Client for making API requests
    ///   - keychainService: Service for secure token storage
    init(
        apiClient: APIClient = .current,
        keychainService: KeychainServiceProtocol = KeychainService()
    ) {
        self.apiClient = apiClient
        self.keychainService = keychainService
    }

    // MARK: - Public Methods

    /// Retrieves the currently authenticated user
    /// - Returns: User if valid tokens exist and API call succeeds, nil otherwise
    func getCurrentUser() async throws -> User? {
        // Check if we have valid tokens
        guard let tokens = try? keychainService.getTokens(),
              !tokens.isExpired else {
            return nil
        }

        // Fetch current user from API
        do {
            let user: User = try await apiClient.request("auth/me")
            return user
        } catch {
            // Clear invalid tokens
            try? keychainService.deleteTokens()
            return nil
        }
    }

    /// Authenticates user with email and password credentials
    /// - Parameter credentials: User's email and password
    /// - Returns: Authentication response with user data and tokens
    /// - Throws: Network or authentication errors
    func login(credentials: AuthCredentials) async throws -> AuthResponse {
        logger.info("Logging in user")

        let bodyDict = [
            "email": credentials.email,
            "password": credentials.password
        ]

        let encoder = JSONEncoder()
        let body = try encoder.encode(bodyDict)

        let response: AuthResponse = try await apiClient.request(
            "auth/login",
            method: .post,
            body: body,
            includeAuth: false
        )

        // Store tokens securely
        try keychainService.saveTokens(response.tokens)

        logger.info("Login successful")
        return response
    }

    /// Creates a new user account with provided credentials
    /// - Parameters:
    ///   - name: User's full name
    ///   - email: User's email address
    ///   - password: Desired password
    /// - Returns: Authentication response with user data and tokens
    /// - Throws: Network or validation errors
    func signup(name: String, email: String, password: String) async throws -> AuthResponse {
        logger.info("Signing up new user")

        let bodyDict = [
            "name": name,
            "email": email,
            "password": password
        ]

        let encoder = JSONEncoder()
        let body = try encoder.encode(bodyDict)

        let response: AuthResponse = try await apiClient.request(
            "auth/register",
            method: .post,
            body: body,
            includeAuth: false
        )

        // Store tokens securely
        try keychainService.saveTokens(response.tokens)

        logger.info("Signup successful")
        return response
    }

    /// Authenticates user using Apple Sign In credentials
    /// - Parameter credentials: Apple sign in credentials containing user info and tokens
    /// - Returns: Authentication response with user data and tokens
    /// - Throws: Network or authentication errors
    func signInWithApple(credentials: AppleSignInCredentials) async throws -> AuthResponse {
        logger.info("Signing in with Apple")

        let bodyDict: [String: Any] = [
            "userId": credentials.userId,
            "identityToken": credentials.identityToken,
            "authorizationCode": credentials.authorizationCode,
            "email": credentials.email as Any,
            "fullName": [
                "givenName": credentials.fullName?.givenName as Any,
                "familyName": credentials.fullName?.familyName as Any
            ]
        ]

        let body = try JSONSerialization.data(withJSONObject: bodyDict)

        let response: AuthResponse = try await apiClient.request(
            "auth/apple",
            method: .post,
            body: body
        )

        // Store tokens securely
        try keychainService.saveTokens(response.tokens)

        logger.info("Apple sign in successful")
        return response
    }

    /// Authenticates user using Google Sign In credentials
    /// - Parameter credentials: Google sign in credentials containing user info and tokens
    /// - Returns: Authentication response with user data and tokens
    /// - Throws: Network or authentication errors
    func signInWithGoogle(credentials: GoogleSignInCredentials) async throws -> AuthResponse {
        logger.info("Signing in with Google")

        let bodyDict: [String: Any] = [
            "userId": credentials.userId,
            "idToken": credentials.idToken,
            "accessToken": credentials.accessToken,
            "email": credentials.email,
            "fullName": credentials.fullName as Any
        ]

        let body = try JSONSerialization.data(withJSONObject: bodyDict)

        let response: AuthResponse = try await apiClient.request(
            "auth/google",
            method: .post,
            body: body
        )

        // Store tokens securely
        try keychainService.saveTokens(response.tokens)

        logger.info("Google sign in successful")
        return response
    }

    /// Logs out the current user and clears stored tokens
    /// - Throws: Error if token deletion fails
    func logout() async throws {
        logger.info("Logging out user")

        // Call logout endpoint
        _ = try? await apiClient.request(
            "auth/logout",
            method: .post
        ) as [String: String]

        // Clear stored tokens
        try keychainService.deleteTokens()

        logger.info("Logout successful")
    }

    /// Refreshes the access token using stored refresh token
    /// - Returns: New authentication tokens
    /// - Throws: AuthServiceError.noTokensFound if no tokens exist, or network errors
    func refreshToken() async throws -> AuthTokens {
        logger.info("Refreshing token")

        guard let tokens = try? keychainService.getTokens() else {
            throw AuthServiceError.noTokensFound
        }

        let bodyDict = [
            "refreshToken": tokens.refreshToken
        ]

        let encoder = JSONEncoder()
        let body = try encoder.encode(bodyDict)

        let response: AuthResponse = try await apiClient.request(
            "auth/refresh",
            method: .post,
            body: body,
            includeAuth: false
        )

        // Store new tokens
        let newTokens = response.tokens
        try keychainService.saveTokens(newTokens)

        logger.info("Token refresh successful")
        return newTokens
    }
}

// MARK: - Auth Service Error

enum AuthServiceError: LocalizedError, Sendable {
    case noTokensFound
    case invalidCredentials
    case networkError
    case unknown

    var errorDescription: String? {
        switch self {
        case .noTokensFound:
            return "No authentication tokens found"
        case .invalidCredentials:
            return "Invalid email or password"
        case .networkError:
            return "Network error occurred"
        case .unknown:
            return "An unknown error occurred"
        }
    }
}
