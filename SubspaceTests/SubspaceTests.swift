//
//  SubspaceTests.swift
//  SubspaceTests
//
//  Created by Clifton Baggerman on 03/10/2025.
//

import Testing
import Foundation
@testable import Subspace

/// Test suite for Home feature following Swift Testing framework
@Suite("Home Feature Tests")
struct HomeFeatureTests {

    // MARK: - HomeViewModel Tests

    @Test("HomeViewModel initializes with idle state")
    @MainActor
    func homeViewModelInitializesWithIdleState() async throws {
        // Given & When
        let viewModel = HomeViewModel()

        // Then
        #expect(viewModel.state == .idle)
        #expect(viewModel.isInteractionEnabled == true)
        #expect(viewModel.recentActivities.isEmpty == true)
    }

    @Test("Loading home data succeeds with mock service")
    @MainActor
    func loadingHomeDataSucceedsWithMockService() async throws {
        // Given
        let mockService = MockMessageService()
        let viewModel = HomeViewModel()

        // When
        await viewModel.loadHomeData(messageService: mockService)

        // Then
        guard case .loaded(let message) = viewModel.state else {
            Issue.record("Expected loaded state, got: \(viewModel.state)")
            return
        }

        #expect(message == "Welcome!")
        #expect(viewModel.isInteractionEnabled == true)
        #expect(viewModel.recentActivities.isEmpty == false)
    }

}

/// Test suite for Profile feature
@Suite("Profile Feature Tests")
struct ProfileFeatureTests {

    @Test("ProfileViewModel initializes with idle state")
    @MainActor
    func profileViewModelInitializesWithIdleState() async throws {
        // Given & When
        let viewModel = ProfileViewModel()

        // Then
        #expect(viewModel.state == .idle)
        #expect(viewModel.isInteractionEnabled == true)
    }

    @Test("Loading profile succeeds with valid user")
    @MainActor
    func loadingProfileSucceedsWithValidUser() async throws {
        // Given
        let mockUserService = MockUserService()
        let viewModel = ProfileViewModel()
        let userId = "test-user-123"

        // When
        await viewModel.loadProfile(userId: userId, userService: mockUserService)

        // Then
        guard case .loaded(let user) = viewModel.state else {
            Issue.record("Expected loaded state, got: \(viewModel.state)")
            return
        }

        #expect(user.id == userId)
        #expect(user.name == "John Doe")
        #expect(viewModel.isInteractionEnabled == true)
    }
}

/// Test suite for Models
@Suite("Model Tests")
struct ModelTests {

    @Test("User model initials are correct")
    func userModelInitialsAreCorrect() {
        // Given
        let user = User(
            id: "test-123",
            name: "John Doe",
            email: "john.doe@example.com",
            avatarURL: nil,
            createdAt: Date()
        )

        // Then
        #expect(user.initials == "JD")
    }
}

// MARK: - Mock Services

/// Mock UserService for testing
final class MockUserService: UserServiceProtocol {
    func fetchUser(id: String) async throws -> User {
        try await Task.sleep(for: .milliseconds(10))
        return User(
            id: id,
            name: "John Doe",
            email: "john.doe@test.com",
            avatarURL: nil,
            createdAt: Date().addingTimeInterval(-86400 * 30)
        )
    }
}
