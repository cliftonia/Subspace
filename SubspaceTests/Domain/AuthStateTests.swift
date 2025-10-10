//
//  AuthStateTests.swift
//  SubspaceTests
//
//  Created by Claude Code on 10/10/2025.
//

import Foundation
import Testing
@testable import Subspace

/// Tests for AuthState domain model
@Suite("AuthState Tests")
struct AuthStateTests {
    // MARK: - Helper

    let mockUser = User(
        id: "test-1",
        name: "Test User",
        email: "test@example.com",
        avatarURL: nil,
        createdAt: Date()
    )

    let anotherUser = User(
        id: "test-2",
        name: "Another User",
        email: "another@example.com",
        avatarURL: nil,
        createdAt: Date()
    )

    // MARK: - Equality Tests

    @Test("Loading states are equal")
    func loadingStatesEqual() {
        // Given/When
        let state1: AuthState = .loading
        let state2: AuthState = .loading

        // Then
        #expect(state1 == state2)
    }

    @Test("Unauthenticated states are equal")
    func unauthenticatedStatesEqual() {
        // Given/When
        let state1: AuthState = .unauthenticated
        let state2: AuthState = .unauthenticated

        // Then
        #expect(state1 == state2)
    }

    @Test("Authenticated states with same user ID are equal")
    func authenticatedStatesWithSameUserEqual() {
        // Given
        let user1 = mockUser
        let user2 = User(
            id: mockUser.id, // Same ID
            name: "Different Name",
            email: "different@example.com",
            avatarURL: nil,
            createdAt: Date()
        )

        // When
        let state1: AuthState = .authenticated(user1)
        let state2: AuthState = .authenticated(user2)

        // Then
        #expect(state1 == state2)
    }

    @Test("Authenticated states with different user IDs are not equal")
    func authenticatedStatesWithDifferentUsersNotEqual() {
        // Given/When
        let state1: AuthState = .authenticated(mockUser)
        let state2: AuthState = .authenticated(anotherUser)

        // Then
        #expect(state1 != state2)
    }

    @Test("Error states with same message are equal")
    func errorStatesWithSameMessageEqual() {
        // Given/When
        let state1: AuthState = .error("Network error")
        let state2: AuthState = .error("Network error")

        // Then
        #expect(state1 == state2)
    }

    @Test("Error states with different messages are not equal")
    func errorStatesWithDifferentMessagesNotEqual() {
        // Given/When
        let state1: AuthState = .error("Network error")
        let state2: AuthState = .error("Auth error")

        // Then
        #expect(state1 != state2)
    }

    @Test("Different state types are not equal")
    func differentStateTypesNotEqual() {
        // Given/When
        let loadingState: AuthState = .loading
        let unauthState: AuthState = .unauthenticated
        let authState: AuthState = .authenticated(mockUser)
        let errorState: AuthState = .error("Error")

        // Then
        #expect(loadingState != unauthState)
        #expect(loadingState != authState)
        #expect(loadingState != errorState)
        #expect(unauthState != authState)
        #expect(unauthState != errorState)
        #expect(authState != errorState)
    }

    // MARK: - Sendable Conformance

    @Test("AuthState is Sendable")
    func authStateIsSendable() {
        // Given
        let state: AuthState = .authenticated(mockUser)

        // When
        Task {
            // Should compile without warnings - AuthState is Sendable
            let _: AuthState = state
        }

        // Then - Compilation success indicates Sendable conformance
        #expect(true)
    }
}

/// Tests for AuthTokens domain model
@Suite("AuthTokens Tests")
struct AuthTokensTests {
    @Test("Tokens are not expired when expiry is in future")
    func tokensNotExpiredWhenFutureExpiry() {
        // Given
        let tokens = AuthTokens(
            accessToken: "access",
            refreshToken: "refresh",
            expiresAt: Date().addingTimeInterval(3600) // 1 hour from now
        )

        // When/Then
        #expect(tokens.isExpired == false)
    }

    @Test("Tokens are expired when expiry is in past")
    func tokensExpiredWhenPastExpiry() {
        // Given
        let tokens = AuthTokens(
            accessToken: "access",
            refreshToken: "refresh",
            expiresAt: Date().addingTimeInterval(-3600) // 1 hour ago
        )

        // When/Then
        #expect(tokens.isExpired == true)
    }

    @Test("Tokens encode and decode correctly")
    func tokensCodecRoundTrip() throws {
        // Given
        let originalTokens = AuthTokens(
            accessToken: "test-access-token",
            refreshToken: "test-refresh-token",
            expiresAt: Date(timeIntervalSince1970: 1234567890)
        )

        // When
        let encoder = JSONEncoder()
        let data = try encoder.encode(originalTokens)

        let decoder = JSONDecoder()
        let decodedTokens = try decoder.decode(AuthTokens.self, from: data)

        // Then
        #expect(decodedTokens.accessToken == originalTokens.accessToken)
        #expect(decodedTokens.refreshToken == originalTokens.refreshToken)
    }
}
