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
        case (.authenticated(let lhsUser), .authenticated(let rhsUser)):
            return lhsUser.id == rhsUser.id
        case (.unauthenticated, .unauthenticated):
            return true
        case (.error(let lhsMessage), .error(let rhsMessage)):
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
    let tokens: AuthTokens
}
