//
//  HomeViewModel.swift
//  Subspace
//
//  Created by Clifton Baggerman on 03/10/2025.
//

import SwiftUI
import Observation
import os

// MARK: - Home State

/// Represents the various states of the home screen
enum HomeState: Equatable {
    case idle
    case loading
    case loaded(message: String)
    case error(String)
}

// MARK: - Home View Model

/// ViewModel for the home screen following MVVM architecture
@MainActor
@Observable
final class HomeViewModel {

    // MARK: - Properties

    private(set) var state: HomeState = .idle
    private(set) var isInteractionEnabled = true
    private(set) var recentActivities: [RecentActivity] = []
    
    // MARK: - Private Properties
    
    private let logger = Logger.app(category: "HomeViewModel")
    private var messageService: MessageServiceProtocol?
    
    // MARK: - Public Methods

    /// Loads all home screen data including welcome message and recent activities
    /// - Parameter messageService: Service to fetch welcome message
    func loadHomeData(messageService: MessageServiceProtocol) async {
        self.messageService = messageService
        await loadWelcomeMessage()
        await loadRecentActivities()
    }

    /// Refreshes all home data from the server
    func refresh() async {
        guard let messageService = messageService else {
            logger.error("Cannot refresh: messageService is nil")
            HapticFeedback.error()
            return
        }

        logger.info("Refreshing home data")
        HapticFeedback.light()
        await loadHomeData(messageService: messageService)
    }

    // MARK: - Private Methods

    /// Fetches the welcome message from the message service
    private func loadWelcomeMessage() async {
        guard let messageService = messageService else {
            logger.error("MessageService not available")
            state = .error("Service unavailable")
            return
        }

        logger.info("Loading welcome message")

        state = .loading
        isInteractionEnabled = false

        do {
            let message = try await messageService.fetchWelcomeMessage()
            state = .loaded(message: message)
            HapticFeedback.success()
            logger.info("Welcome message loaded successfully")
        } catch {
            logger.error("Failed to load welcome message: \(error)")
            state = .error("Failed to load welcome message")
            HapticFeedback.error()
        }

        isInteractionEnabled = true
    }

    /// Loads recent user activities for display on the home screen
    private func loadRecentActivities() async {
        logger.debug("Loading recent activities")

        // Simulate loading recent activities
        try? await Task.sleep(for: .milliseconds(300))

        // For now, use sample data
        self.recentActivities = RecentActivity.samples

        logger.info("Loaded \(self.recentActivities.count) recent activities")
    }
}