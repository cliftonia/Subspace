//
//  AuthService.swift
//  Subspace
//
//  Created by Clifton Baggerman on 04/10/2025.
//

import Foundation
import os

// MARK: - Auth Service Protocol

protocol AuthServiceProtocol: Sendable {
    func getCurrentUser() async throws -> User?
    func login(credentials: AuthCredentials) async throws -> AuthResponse
    func signup(name: String, email: String, password: String) async throws -> AuthResponse
    func signInWithApple(
        userId: String,
        identityToken: String,
        authorizationCode: String,
        email: String?,
        fullName: PersonNameComponents?
    ) async throws -> AuthResponse
    func signInWithGoogle(
        userId: String,
        idToken: String,
        accessToken: String,
        email: String,
        fullName: String?
    ) async throws -> AuthResponse
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

    init(
        apiClient: APIClient = .current,
        keychainService: KeychainServiceProtocol = KeychainService()
    ) {
        self.apiClient = apiClient
        self.keychainService = keychainService
    }

    // MARK: - Public Methods

    /// Get currently authenticated user
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

    /// Login with email and password
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
            body: body
        )

        // Store tokens securely
        try keychainService.saveTokens(response.tokens)

        logger.info("Login successful")
        return response
    }

    /// Sign up new user
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
            "auth/signup",
            method: .post,
            body: body
        )

        // Store tokens securely
        try keychainService.saveTokens(response.tokens)

        logger.info("Signup successful")
        return response
    }

    /// Sign in with Apple
    func signInWithApple(
        userId: String,
        identityToken: String,
        authorizationCode: String,
        email: String?,
        fullName: PersonNameComponents?
    ) async throws -> AuthResponse {
        logger.info("Signing in with Apple")

        let bodyDict: [String: Any] = [
            "userId": userId,
            "identityToken": identityToken,
            "authorizationCode": authorizationCode,
            "email": email as Any,
            "fullName": [
                "givenName": fullName?.givenName as Any,
                "familyName": fullName?.familyName as Any
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

    /// Sign in with Google
    func signInWithGoogle(
        userId: String,
        idToken: String,
        accessToken: String,
        email: String,
        fullName: String?
    ) async throws -> AuthResponse {
        logger.info("Signing in with Google")

        let bodyDict: [String: Any] = [
            "userId": userId,
            "idToken": idToken,
            "accessToken": accessToken,
            "email": email,
            "fullName": fullName as Any
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

    /// Logout current user
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

    /// Refresh access token
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

        let response: AuthTokens = try await apiClient.request(
            "auth/refresh",
            method: .post,
            body: body
        )

        // Store new tokens
        try keychainService.saveTokens(response)

        logger.info("Token refresh successful")
        return response
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
