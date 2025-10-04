//
//  SubspaceTests.swift
//  SubspaceTests
//
//  Created by Clifton Baggerman on 03/10/2025.
//

import Testing
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
        let expectedMessage = "Test Welcome Message"
        let mockService = MockMessageService(customMessage: expectedMessage)
        let viewModel = HomeViewModel()
        
        // When
        await viewModel.loadHomeData(messageService: mockService)
        
        // Then
        guard case .loaded(let message) = viewModel.state else {
            Issue.record("Expected loaded state, got: \(viewModel.state)")
            return
        }
        
        #expect(message == expectedMessage)
        #expect(viewModel.isInteractionEnabled == true)
        #expect(viewModel.recentActivities.isEmpty == false)
    }
    
    @Test("Loading home data handles service errors")
    @MainActor
    func loadingHomeDataHandlesServiceErrors() async throws {
        // Given
        let failingService = MockMessageService(shouldFail: true)
        let viewModel = HomeViewModel()
        
        // When
        await viewModel.loadHomeData(messageService: failingService)
        
        // Then
        guard case .error(let errorMessage) = viewModel.state else {
            Issue.record("Expected error state, got: \(viewModel.state)")
            return
        }
        
        #expect(errorMessage == "Failed to load welcome message")
        #expect(viewModel.isInteractionEnabled == true)
    }
    
    @Test("Refresh reloads data correctly")
    @MainActor
    func refreshReloadsDataCorrectly() async throws {
        // Given
        let mockService = MockMessageService(customMessage: "Initial Message")
        let viewModel = HomeViewModel()
        await viewModel.loadHomeData(messageService: mockService)
        
        guard case .loaded = viewModel.state else {
            Issue.record("Initial load should succeed")
            return
        }
        
        // When - Refresh with different service
        let newService = MockMessageService(customMessage: "Refreshed Message")
        // Note: In real implementation, refresh would use the same service
        // This test simulates the refresh behavior
        await viewModel.loadHomeData(messageService: newService)
        
        // Then
        guard case .loaded(let refreshedMessage) = viewModel.state else {
            Issue.record("Refresh should succeed")
            return
        }
        
        #expect(refreshedMessage == "Refreshed Message")
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

/// Test suite for Services
@Suite("Service Tests")
struct ServiceTests {
    
    @Test("MessageService returns welcome message")
    func messageServiceReturnsWelcomeMessage() async throws {
        // Given
        let service = MessageService()
        
        // When
        let message = try await service.fetchWelcomeMessage()
        
        // Then
        #expect(message.isEmpty == false)
        #expect(message.contains("Welcome") || message.contains("Ready") || message.contains("adventure"))
    }
    
    @Test("MockMessageService behaves correctly")
    func mockMessageServiceBehavesCorrectly() async throws {
        // Given - Success case
        let successService = MockMessageService(customMessage: "Custom Test Message")
        
        // When
        let message = try await successService.fetchWelcomeMessage()
        
        // Then
        #expect(message == "Custom Test Message")
        
        // Given - Failure case
        let failingService = MockMessageService(shouldFail: true)
        
        // When & Then
        await #expect(throws: NetworkError.self) {
            try await failingService.fetchWelcomeMessage()
        }
    }
    
    @Test("UserService returns valid user")
    func userServiceReturnsValidUser() async throws {
        // Given
        let service = UserService()
        let userId = "test-123"
        
        // When
        let user = try await service.fetchUser(id: userId)
        
        // Then
        #expect(user.id == userId)
        #expect(user.name.isEmpty == false)
        #expect(user.email.isEmpty == false)
        #expect(user.initials.isEmpty == false)
    }
    
    @Test("SettingsService returns app version")
    func settingsServiceReturnsAppVersion() {
        // Given
        let service = SettingsService()
        
        // When
        let version = service.getAppVersion()
        
        // Then
        #expect(version.isEmpty == false)
        #expect(version.contains(".")) // Should contain version format like "1.0.0"
    }
}

/// Test suite for Models
@Suite("Model Tests")
struct ModelTests {
    
    @Test("User model provides correct computed properties")
    func userModelProvidesCorrectComputedProperties() {
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
        #expect(user.displayName == "John Doe")
        
        // Test with empty name
        let userWithoutName = User(
            id: "test-456",
            name: "",
            email: "user@example.com",
            avatarURL: nil,
            createdAt: Date()
        )
        
        #expect(userWithoutName.displayName == "user@example.com")
    }
    
    @Test("NetworkError provides localized descriptions")
    func networkErrorProvidesLocalizedDescriptions() {
        // Given
        let errors: [NetworkError] = [
            .noConnection,
            .timeout,
            .serverError(code: 500),
            .invalidResponse,
            .decodingFailed,
            .unknown
        ]
        
        // Then
        for error in errors {
            #expect(error.errorDescription?.isEmpty == false)
            #expect(error.failureReason?.isEmpty == false)
            #expect(error.recoverySuggestion?.isEmpty == false)
        }
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

// MARK: - State Extensions for Testing

extension HomeState: Equatable {
    static func == (lhs: HomeState, rhs: HomeState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle),
             (.loading, .loading):
            return true
        case (.loaded(let lhsMessage), .loaded(let rhsMessage)):
            return lhsMessage == rhsMessage
        case (.error(let lhsError), .error(let rhsError)):
            return lhsError == rhsError
        default:
            return false
        }
    }
}

extension ProfileState: Equatable {
    static func == (lhs: ProfileState, rhs: ProfileState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle),
             (.loading, .loading):
            return true
        case (.loaded(let lhsUser), .loaded(let rhsUser)):
            return lhsUser.id == rhsUser.id
        case (.error(let lhsError), .error(let rhsError)):
            return lhsError == rhsError
        default:
            return false
        }
    }
}
