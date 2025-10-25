//
//  AppDependencies.swift
//  Subspace
//
//  Created by Clifton Baggerman on 03/10/2025.
//

import Foundation
import Observation

/// Container for app-wide dependencies following dependency injection pattern
@Observable
final class AppDependencies {
    // MARK: - Services

    let messageService: MessageServiceProtocol
    let userService: UserServiceProtocol
    let settingsService: SettingsServiceProtocol
    let authService: AuthServiceProtocol

    // MARK: - Initialization

    init(
        messageService: MessageServiceProtocol? = nil,
        userService: UserServiceProtocol? = nil,
        settingsService: SettingsServiceProtocol? = nil,
        authService: AuthServiceProtocol? = nil
    ) {
        self.messageService = messageService ?? MessageService()
        self.userService = userService ?? UserService()
        self.settingsService = settingsService ?? SettingsService()
        self.authService = authService ?? AuthService()
    }
}

// MARK: - Testing Support

extension AppDependencies {
    /// Create dependencies with mock services for testing
    static func mock(
        shouldUserServiceFail: Bool = false,
        shouldMessageServiceFail: Bool = false
    ) -> AppDependencies {
        AppDependencies(
            messageService: MockMessageService(shouldFail: shouldMessageServiceFail)
        )
    }
}

// MARK: - Service Protocols

protocol MessageServiceProtocol: Sendable {
    func fetchWelcomeMessage() async throws -> String
}

protocol UserServiceProtocol: Sendable {
    func fetchUser(id: String) async throws -> User
}

protocol SettingsServiceProtocol: Sendable {
    func getAppVersion() -> String
}
