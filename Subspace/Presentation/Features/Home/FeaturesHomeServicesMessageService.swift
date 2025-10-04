//
//  MessageService.swift
//  Subspace
//
//  Created by Clifton Baggerman on 03/10/2025.
//

import Foundation
import os

/// Implementation of message service for fetching app messages
final class MessageService: MessageServiceProtocol, Sendable {

    // MARK: - Properties

    private let apiClient: APIClient
    private let userId: String

    // MARK: - Initialization

    init(apiClient: APIClient = .current, userId: String = "user-1") {
        self.apiClient = apiClient
        self.userId = userId
        
        let logger = Logger.app(category: "MessageService")
        logger.debug("MessageService initialized for user: \(userId)")
    }

    // MARK: - MessageServiceProtocol

    func fetchWelcomeMessage() async throws -> String {
        let logger = Logger.app(category: "MessageService")
        logger.debug("Fetching welcome message")

        do {
            let messages = try await apiClient.fetchMessages(userId: userId)

            // Get the first unread message or any message
            if let firstMessage = messages.first {
                logger.info("Welcome message fetched: \(firstMessage.content)")
                return firstMessage.content
            } else {
                logger.info("No messages found, using default")
                return "Welcome to Subspace!"
            }
        } catch {
            logger.error("Failed to fetch messages: \(error.localizedDescription)")
            // Return a default message on error
            return "Welcome to Subspace!"
        }
    }
}

// MARK: - Mock Implementation

/// Mock implementation for testing and previews
final class MockMessageService: MessageServiceProtocol, Sendable {
    
    // MARK: - Properties
    
    private let shouldFail: Bool
    private let customMessage: String?
    
    // MARK: - Initialization
    
    init(shouldFail: Bool = false, customMessage: String? = nil) {
        self.shouldFail = shouldFail
        self.customMessage = customMessage
    }
    
    // MARK: - MessageServiceProtocol
    
    func fetchWelcomeMessage() async throws -> String {
        try await Task.sleep(for: .milliseconds(100))
        
        if shouldFail {
            throw NetworkError.serverError(code: 500)
        }
        
        return customMessage ?? "Mock Welcome Message!"
    }
}