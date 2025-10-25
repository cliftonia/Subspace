//
//  UserTests.swift
//  SubspaceTests
//
//

import Foundation
import Testing
@testable import Subspace

/// Tests for User domain model
@Suite("User Model Tests")
struct UserTests {
    @Test("User initials extracted correctly for full name")
    func userInitialsFromFullName() {
        // Given
        let user = User(
            id: "test-1",
            name: "Jean-Luc Picard",
            email: "picard@starfleet.com",
            avatarURL: nil,
            createdAt: Date()
        )

        // When/Then
        #expect(user.initials == "JP")
    }

    @Test("User initials extracted correctly for single name")
    func userInitialsFromSingleName() {
        // Given
        let user = User(
            id: "test-2",
            name: "Spock",
            email: "spock@starfleet.com",
            avatarURL: nil,
            createdAt: Date()
        )

        // When/Then
        #expect(user.initials == "S")
    }

    @Test("User display name uses name when available")
    func displayNameUsesName() {
        // Given
        let user = User(
            id: "test-3",
            name: "James Kirk",
            email: "kirk@starfleet.com",
            avatarURL: nil,
            createdAt: Date()
        )

        // When/Then
        #expect(user.displayName == "James Kirk")
    }

    @Test("User display name falls back to email when name is empty")
    func displayNameFallsBackToEmail() {
        // Given
        let user = User(
            id: "test-4",
            name: "",
            email: "anonymous@starfleet.com",
            avatarURL: nil,
            createdAt: Date()
        )

        // When/Then
        #expect(user.displayName == "anonymous@starfleet.com")
    }

    @Test("User encodes and decodes correctly")
    func userCodecRoundTrip() throws {
        // Given
        let originalUser = User(
            id: "test-5",
            name: "William Riker",
            email: "riker@starfleet.com",
            avatarURL: URL(string: "https://example.com/riker.jpg"),
            createdAt: Date(timeIntervalSince1970: 1234567890)
        )

        // When
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let data = try encoder.encode(originalUser)

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let decodedUser = try decoder.decode(User.self, from: data)

        // Then
        #expect(decodedUser.id == originalUser.id)
        #expect(decodedUser.name == originalUser.name)
        #expect(decodedUser.email == originalUser.email)
        #expect(decodedUser.avatarURL == originalUser.avatarURL)
    }

    @Test("User UserID typealias works correctly")
    func userIDTypeAlias() {
        // Given
        let userId: User.UserID = "test-user-123"

        // When
        let user = User(
            id: userId,
            name: "Test User",
            email: "test@example.com",
            avatarURL: nil,
            createdAt: Date()
        )

        // Then
        #expect(user.id == userId)
        #expect(user.id == "test-user-123")
    }
}
