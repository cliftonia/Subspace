//
//  HomeViewModelTests.swift
//  Subspace
//
//  Created by Clifton Baggerman on 04/10/2025.
//

import Testing
@testable import Subspace

@Suite("Home ViewModel Tests")
struct HomeViewModelTests {

    @Test("Initial state is idle")
    @MainActor
    func initialStateIsIdle() {
        // Given/When
        let viewModel = HomeViewModel()

        // Then
        #expect(viewModel.state == .idle)
        #expect(viewModel.recentActivities.isEmpty)
    }

    @Test("Load home data updates state to loaded")
    @MainActor
    func loadHomeDataUpdatesStateToLoaded() async {
        // Given
        let mockService = MockMessageService()
        let viewModel = HomeViewModel()

        // When
        await viewModel.loadHomeData(messageService: mockService)

        // Then
        switch viewModel.state {
        case .loaded:
            break // Success
        default:
            Issue.record("Expected loaded state, got \(viewModel.state)")
        }
    }

    @Test("Refresh reloads data")
    @MainActor
    func refreshReloadsData() async {
        // Given
        let mockService = MockMessageService()
        let viewModel = HomeViewModel()

        // Load initial data
        await viewModel.loadHomeData(messageService: mockService)

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

// MARK: - Mock Message Service

struct MockMessageService: MessageServiceProtocol, Sendable {
    func fetchWelcomeMessage() async throws -> String {
        return "Welcome!"
    }
}

