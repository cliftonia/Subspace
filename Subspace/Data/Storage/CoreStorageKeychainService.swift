//
//  KeychainService.swift
//  Subspace
//
//  Created by Clifton Baggerman on 04/10/2025.
//

import Foundation
import Security
import os

// MARK: - Keychain Service Protocol

protocol KeychainServiceProtocol: Sendable {
    func saveTokens(_ tokens: AuthTokens) throws
    func getTokens() throws -> AuthTokens
    func deleteTokens() throws
}

// MARK: - Keychain Service

/// Service for securely storing sensitive data in the iOS Keychain
final class KeychainService: KeychainServiceProtocol, Sendable {

    // MARK: - Properties

    private let logger = Logger.app(category: "KeychainService")
    private let service: String

    // MARK: - Constants

    private enum Keys {
        static let tokens = "auth_tokens"
    }

    // MARK: - Initialization

    init(service: String = Bundle.main.bundleIdentifier ?? "com.Subspace") {
        self.service = service
    }

    // MARK: - Public Methods

    /// Save authentication tokens to Keychain
    func saveTokens(_ tokens: AuthTokens) throws {
        logger.debug("Saving tokens to Keychain")

        let encoder = JSONEncoder()
        let data = try encoder.encode(tokens)

        try save(data, forKey: Keys.tokens)
        logger.info("Tokens saved successfully")
    }

    /// Retrieve authentication tokens from Keychain
    func getTokens() throws -> AuthTokens {
        logger.debug("Retrieving tokens from Keychain")

        let data = try read(forKey: Keys.tokens)

        let decoder = JSONDecoder()
        let tokens = try decoder.decode(AuthTokens.self, from: data)

        logger.info("Tokens retrieved successfully")
        return tokens
    }

    /// Delete authentication tokens from Keychain
    func deleteTokens() throws {
        logger.debug("Deleting tokens from Keychain")

        try delete(forKey: Keys.tokens)
        logger.info("Tokens deleted successfully")
    }

    // MARK: - Private Methods

    /// Save data to Keychain
    private func save(_ data: Data, forKey key: String) throws {
        // Create query
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlock
        ]

        // Delete any existing item
        SecItemDelete(query as CFDictionary)

        // Add new item
        let status = SecItemAdd(query as CFDictionary, nil)

        guard status == errSecSuccess else {
            logger.error("Failed to save to Keychain: \\(status)")
            throw KeychainError.saveFailed(status: status)
        }
    }

    /// Read data from Keychain
    private func read(forKey key: String) throws -> Data {
        // Create query
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        // Execute query
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        guard status == errSecSuccess else {
            logger.error("Failed to read from Keychain: \\(status)")
            throw KeychainError.readFailed(status: status)
        }

        guard let data = result as? Data else {
            logger.error("Invalid data format in Keychain")
            throw KeychainError.invalidData
        }

        return data
    }

    /// Delete data from Keychain
    private func delete(forKey key: String) throws {
        // Create query
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key
        ]

        // Execute delete
        let status = SecItemDelete(query as CFDictionary)

        guard status == errSecSuccess || status == errSecItemNotFound else {
            logger.error("Failed to delete from Keychain: \\(status)")
            throw KeychainError.deleteFailed(status: status)
        }
    }
}

// MARK: - Keychain Error

enum KeychainError: LocalizedError, Sendable {
    case saveFailed(status: OSStatus)
    case readFailed(status: OSStatus)
    case deleteFailed(status: OSStatus)
    case invalidData

    var errorDescription: String? {
        switch self {
        case .saveFailed(let status):
            return "Failed to save to Keychain (status: \\(status))"
        case .readFailed(let status):
            return "Failed to read from Keychain (status: \\(status))"
        case .deleteFailed(let status):
            return "Failed to delete from Keychain (status: \\(status))"
        case .invalidData:
            return "Invalid data format in Keychain"
        }
    }
}
