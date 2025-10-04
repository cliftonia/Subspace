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

    init(apiClient: APIClient = .current, cache: Cache<String, User>? = nil) {
        self.apiClient = apiClient
        self.cache = cache ?? Cache<String, User>(defaultExpiration: 300) // 5 minutes
        
        let logger = Logger.app(category: "UserService")
        logger.debug("UserService initialized with caching")
    }

    // MARK: - UserServiceProtocol

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
    
    init() {
        let logger = Logger.app(category: "SettingsService")
        logger.debug("SettingsService initialized")
    }
    
    // MARK: - SettingsServiceProtocol
    
    func getAppVersion() -> String {
        let logger = Logger.app(category: "SettingsService")
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        
        logger.debug("App version: \(version) (\(build))")
        return "\(version) (\(build))"
    }
}