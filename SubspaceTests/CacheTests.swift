//
//  CacheTests.swift
//  Subspace
//
//  Created by Clifton Baggerman on 04/10/2025.
//

import Testing
@testable import Subspace

@Suite("Cache Tests")
struct CacheTests {

    @Test("Set and get value succeeds")
    func setAndGetValueSucceeds() {
        // Given
        let cache = Cache<String, String>(defaultExpiration: 60)
        let key = "test-key"
        let value = "test-value"

        // When
        cache.set(key, value: value)
        let retrieved = cache.get(key)

        // Then
        #expect(retrieved == value)
    }

    @Test("Get non-existent key returns nil")
    func getNonExistentKeyReturnsNil() {
        // Given
        let cache = Cache<String, String>(defaultExpiration: 60)

        // When
        let retrieved = cache.get("non-existent-key")

        // Then
        #expect(retrieved == nil)
    }

    @Test("Remove value deletes from cache")
    func removeValueDeletesFromCache() {
        // Given
        let cache = Cache<String, String>(defaultExpiration: 60)
        let key = "test-key"
        cache.set(key, value: "test-value")

        // When
        cache.remove(key)
        let retrieved = cache.get(key)

        // Then
        #expect(retrieved == nil)
    }

    @Test("Clear removes all values")
    func clearRemovesAllValues() {
        // Given
        let cache = Cache<String, String>(defaultExpiration: 60)
        cache.set("key1", value: "value1")
        cache.set("key2", value: "value2")
        cache.set("key3", value: "value3")

        // When
        cache.clear()

        // Then
        #expect(cache.get("key1") == nil)
        #expect(cache.get("key2") == nil)
        #expect(cache.get("key3") == nil)
    }

    @Test("Expired entries return nil")
    func expiredEntriesReturnNil() async {
        // Given
        let cache = Cache<String, String>(defaultExpiration: 0.1) // 100ms
        let key = "test-key"
        cache.set(key, value: "test-value")

        // Wait for expiration
        try? await Task.sleep(for: .milliseconds(150))

        // When
        let retrieved = cache.get(key)

        // Then
        #expect(retrieved == nil)
    }

    @Test("Clean expired removes only expired entries")
    func cleanExpiredRemovesOnlyExpiredEntries() async {
        // Given
        let cache = Cache<String, String>()
        cache.set("expired", value: "value1", expiration: 0.1) // 100ms
        cache.set("valid", value: "value2", expiration: 60) // 60s

        // Wait for first entry to expire
        try? await Task.sleep(for: .milliseconds(150))

        // When
        cache.cleanExpired()

        // Then
        #expect(cache.get("expired") == nil)
        #expect(cache.get("valid") == "value2")
    }

    @Test("Custom expiration overrides default")
    func customExpirationOverridesDefault() async {
        // Given
        let cache = Cache<String, String>(defaultExpiration: 60)
        let key = "test-key"
        cache.set(key, value: "test-value", expiration: 0.1) // Override with 100ms

        // Wait for expiration
        try? await Task.sleep(for: .milliseconds(150))

        // When
        let retrieved = cache.get(key)

        // Then
        #expect(retrieved == nil)
    }
}
