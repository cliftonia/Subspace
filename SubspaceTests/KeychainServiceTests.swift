//
//  KeychainServiceTests.swift
//  Subspace
//
//  Created by Clifton Baggerman on 04/10/2025.
//

import Foundation
import Testing
@testable import Subspace

@Suite("Keychain Service Tests")
struct KeychainServiceTests {

    let testService = "com.test.Subspace"

    @Test("Save and retrieve tokens succeeds")
    func saveAndRetrieveTokens() throws {
        // Given
        let keychainService = KeychainService(service: testService)
        let expirationDate = Date().addingTimeInterval(3600) // 1 hour from now
        let testTokens = AuthTokens(
            accessToken: "test-access-token",
            refreshToken: "test-refresh-token",
            expiresAt: expirationDate
        )

        // When
        try keychainService.saveTokens(testTokens)
        let retrievedTokens = try keychainService.getTokens()

        // Then
        #expect(retrievedTokens.accessToken == testTokens.accessToken)
        #expect(retrievedTokens.refreshToken == testTokens.refreshToken)

        // Cleanup
        try? keychainService.deleteTokens()
    }

    @Test("Delete tokens removes from keychain")
    func deleteTokensRemovesFromKeychain() throws {
        // Given
        let keychainService = KeychainService(service: testService)
        let expirationDate = Date().addingTimeInterval(3600)
        let testTokens = AuthTokens(
            accessToken: "test-access-token",
            refreshToken: "test-refresh-token",
            expiresAt: expirationDate
        )

        // Save tokens first
        try keychainService.saveTokens(testTokens)
        #expect((try? keychainService.getTokens()) != nil)

        // When
        try keychainService.deleteTokens()

        // Then
        #expect((try? keychainService.getTokens()) == nil)
    }

    @Test("Get tokens returns nil when not stored")
    func getTokensReturnsNilWhenNotStored() throws {
        // Given
        let keychainService = KeychainService(service: testService + ".empty")

        // Ensure no tokens exist
        try? keychainService.deleteTokens()

        // When
        let tokens = try? keychainService.getTokens()

        // Then
        #expect(tokens == nil)
    }
}
