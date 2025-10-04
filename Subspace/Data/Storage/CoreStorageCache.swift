//
//  Cache.swift
//  Subspace
//
//  Created by Clifton Baggerman on 03/10/2025.
//

import Foundation
import os

// MARK: - Cache Entry

private struct CacheEntry<Value> {
    let value: Value
    let expirationDate: Date

    var isExpired: Bool {
        Date() > expirationDate
    }
}

// MARK: - Cache

/// Thread-safe in-memory cache with expiration
final class Cache<Key: Hashable, Value>: @unchecked Sendable {

    // MARK: - Properties

    private let lock = NSLock()
    private var storage: [Key: CacheEntry<Value>] = [:]
    private let defaultExpiration: TimeInterval
    private let logger = Logger.app(category: "Cache")

    // MARK: - Initialization

    init(defaultExpiration: TimeInterval = 300) { // 5 minutes default
        self.defaultExpiration = defaultExpiration
    }

    // MARK: - Public Methods

    /// Get value from cache
    func get(_ key: Key) -> Value? {
        lock.lock()
        defer { lock.unlock() }

        guard let entry = storage[key] else {
            return nil
        }

        if entry.isExpired {
            storage.removeValue(forKey: key)
            logger.debug("Cache expired for key: \(String(describing: key))")
            return nil
        }

        logger.debug("Cache hit for key: \(String(describing: key))")
        return entry.value
    }

    /// Set value in cache with optional custom expiration
    func set(_ key: Key, value: Value, expiration: TimeInterval? = nil) {
        lock.lock()
        defer { lock.unlock() }

        let expirationTime = expiration ?? defaultExpiration
        let expirationDate = Date().addingTimeInterval(expirationTime)

        storage[key] = CacheEntry(value: value, expirationDate: expirationDate)
        logger.debug("Cache set for key: \(String(describing: key))")
    }

    /// Remove value from cache
    func remove(_ key: Key) {
        lock.lock()
        defer { lock.unlock() }

        storage.removeValue(forKey: key)
        logger.debug("Cache removed for key: \(String(describing: key))")
    }

    /// Clear all cached values
    func clear() {
        lock.lock()
        defer { lock.unlock() }

        storage.removeAll()
        logger.info("Cache cleared")
    }

    /// Remove all expired entries
    func cleanExpired() {
        lock.lock()
        defer { lock.unlock() }

        let expiredKeys = storage.filter { $0.value.isExpired }.map { $0.key }
        expiredKeys.forEach { storage.removeValue(forKey: $0) }

        if !expiredKeys.isEmpty {
            logger.info("Removed \(expiredKeys.count) expired entries")
        }
    }
}
