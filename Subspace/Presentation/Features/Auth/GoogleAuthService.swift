//
//  GoogleAuthService.swift
//  Subspace
//
//  Created by Clifton Baggerman on 04/10/2025.
//

import Foundation
import os

// MARK: - Google Auth Result

struct GoogleAuthResult: Sendable {
    let userId: String
    let email: String
    let fullName: String?
    let profileImageURL: String?
    let idToken: String
    let accessToken: String
}

// MARK: - Google Auth Service Protocol

protocol GoogleAuthServiceProtocol: Sendable {
    func signIn() async throws -> GoogleAuthResult
    func signOut() async throws
}

// MARK: - Google Auth Service

/// Service for Google Sign-In integration
/// NOTE: Placeholder - requires GoogleSignIn SDK (https://github.com/google/GoogleSignIn-iOS)
@MainActor
final class GoogleAuthService: GoogleAuthServiceProtocol {

    // MARK: - Properties

    private let logger = Logger.app(category: "GoogleAuthService")

    // MARK: - Public Methods

    /// Initiates Google Sign-In flow
    /// - Returns: Google authentication result with user data and tokens
    /// - Throws: GoogleAuthError.notImplemented as this is a placeholder
    func signIn() async throws -> GoogleAuthResult {
        logger.warning("Google Sign-In not implemented")
        throw GoogleAuthError.notImplemented
    }

    /// Signs out the current Google user
    /// - Throws: GoogleAuthError.notImplemented as this is a placeholder
    func signOut() async throws {
        logger.warning("Google Sign-Out not implemented")
        throw GoogleAuthError.notImplemented
    }
}

// MARK: - Google Auth Error

enum GoogleAuthError: LocalizedError, Sendable {
    case notImplemented
    case userCancelled
    case missingIDToken
    case authorizationFailed
    case unknown

    var errorDescription: String? {
        switch self {
        case .notImplemented:
            return "Google Sign-In not yet implemented"
        case .userCancelled:
            return "Sign in was cancelled"
        case .missingIDToken:
            return "Missing ID token from Google"
        case .authorizationFailed:
            return "Authorization failed"
        case .unknown:
            return "An unknown error occurred"
        }
    }
}
