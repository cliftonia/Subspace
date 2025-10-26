//
//  ProfileViewModelTests.swift
//  Subspace
//
//  Created by Clifton Baggerman on 04/10/2025.
//

import Foundation
import Testing
@testable import Subspace

@Suite("Profile ViewModel Tests")
struct ProfileViewModelTests {

    @Test("Initial state is idle")
    @MainActor
    func initialStateIsIdle() {
        // Given/When
        let viewModel = ProfileViewModel()

        // Then
        switch viewModel.state {
        case .idle:
            break // Success
        default:
            Issue.record("Expected idle state")
        }
    }

    @Test("Load profile updates state to loaded")
    @MainActor
    func loadProfileUpdatesStateToLoaded() async {
        // Given
        let viewModel = ProfileViewModel()
        let mockService = MockProfileUserService()

        // When
        await viewModel.loadProfile(userId: "test-user-id", userService: mockService)

        // Then
        switch viewModel.state {
        case .loaded:
            break // Success
        default:
            Issue.record("Expected loaded state with user data")
        }
    }

    @Test("Refresh reloads profile")
    @MainActor
    func refreshReloadsProfile() async {
        // Given
        let viewModel = ProfileViewModel()
        let mockService = MockProfileUserService()
        await viewModel.loadProfile(userId: "test-user-id", userService: mockService)

        // When
        await viewModel.refresh()

        // Then
        switch viewModel.state {
        case .loaded:
            break // Success
        default:
            Issue.record("Expected loaded state after refresh")
        }
    }
}

// MARK: - Mock User Service

struct MockProfileUserService: UserServiceProtocol, Sendable {
    func fetchUser(id: String) async throws -> User {
        return User(
            id: id,
            name: "Test User",
            email: "test@example.com",
            avatarURL: nil,
            createdAt: Date()
        )
    }
}

