//
//  UserService.swift
//  Subspace
//
//  Created by Clifton Baggerman on 03/10/2025.
//

import Foundation
import os

/// Service for managing user data and operations
final class UserService: UserServiceProtocol, Sendable {
    // MARK: - Properties

    private let apiClient: APIClient
    private let cache: Cache<String, User>

    // MARK: - Initialization

    /// Initializes the user service with caching support
    /// - Parameters:
    ///   - apiClient: Client for making API requests
    ///   - cache: Optional cache instance (creates default 5-minute cache if nil)
    init(apiClient: APIClient = .current, cache: Cache<String, User>? = nil) {
        self.apiClient = apiClient
        self.cache = cache ?? Cache<String, User>(defaultExpiration: 300) // 5 minutes

        let logger = Logger.app(category: "UserService")
        logger.debug("UserService initialized with caching")
    }

    // MARK: - UserServiceProtocol

    /// Fetches a user by ID with automatic caching
    /// - Parameter id: The user ID to fetch
    /// - Returns: User data from cache or API
    /// - Throws: Network errors if API request fails
    func fetchUser(id: String) async throws -> User {
        let logger = Logger.app(category: "UserService")
        logger.debug("Fetching user with ID: \(id)")

        // Check cache first
        if let cachedUser = cache.get(id) {
            logger.info("Returning cached user: \(cachedUser.name)")
            return cachedUser
        }

        // Fetch from API
        let user = try await apiClient.fetchUser(id: id)

        logger.info("User fetched successfully: \(user.name)")

        // Store in cache
        cache.set(id, value: user)

        return user
    }
}

// MARK: - Settings Service

/// Service for app settings and configuration
final class SettingsService: SettingsServiceProtocol {
    // MARK: - Initialization

    /// Initializes the settings service
    init() {
        let logger = Logger.app(category: "SettingsService")
        logger.debug("SettingsService initialized")
    }

    // MARK: - SettingsServiceProtocol

    /// Retrieves the current app version and build number
    /// - Returns: Formatted version string (e.g., "1.0.0 (1)")
    func getAppVersion() -> String {
        let logger = Logger.app(category: "SettingsService")
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"

        logger.debug("App version: \(version) (\(build))")
        return "\(version) (\(build))"
    }
}
