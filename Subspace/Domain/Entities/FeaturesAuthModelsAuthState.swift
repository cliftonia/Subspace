//
//  AuthState.swift
//  Subspace
//
//  Created by Clifton Baggerman on 04/10/2025.
//

import Foundation

// MARK: - Auth State

enum AuthState: Equatable, Sendable {
    case loading
    case authenticated(User)
    case unauthenticated
    case error(String)

    static func == (lhs: AuthState, rhs: AuthState) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading):
            return true
        case let (.authenticated(lhsUser), .authenticated(rhsUser)):
            return lhsUser.id == rhsUser.id
        case (.unauthenticated, .unauthenticated):
            return true
        case let (.error(lhsMessage), .error(rhsMessage)):
            return lhsMessage == rhsMessage
        default:
            return false
        }
    }
}

// MARK: - Auth Credentials

struct AuthCredentials: Sendable {
    let email: String
    let password: String
}

// MARK: - Auth Tokens

nonisolated struct AuthTokens: Codable, Sendable {
    let accessToken: String
    let refreshToken: String
    let expiresAt: Date

    var isExpired: Bool {
        Date() >= expiresAt
    }
}

// MARK: - Auth Response

nonisolated struct AuthResponse: Codable, Sendable {
    let user: User
    let token: String

    enum CodingKeys: String, CodingKey {
        case user
        case token
    }

    /// Converts backend token response to AuthTokens format
    var tokens: AuthTokens {
        // JWT tokens from backend are valid for 24 hours
        let expiresAt = Date().addingTimeInterval(24 * 3600)
        return AuthTokens(
            accessToken: token,
            refreshToken: token, // Backend uses same token for refresh
            expiresAt: expiresAt
        )
    }
}
