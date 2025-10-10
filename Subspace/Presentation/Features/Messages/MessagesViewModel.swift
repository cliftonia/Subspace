//
//  MessagesViewModel.swift
//  Subspace
//
//  Created by Clifton Baggerman on 03/10/2025.
//

import Observation
import os
import SwiftUI

// MARK: - Messages State

/// Represents the various states of the messages list screen
enum MessagesState: Equatable {
    case idle
    case loading
    case loaded([MessageResponse])
    case error(String)

    /// Compares two MessagesState instances for equality
    /// - Parameters:
    ///   - lhs: Left-hand side state
    ///   - rhs: Right-hand side state
    /// - Returns: True if states are equal
    static func == (lhs: MessagesState, rhs: MessagesState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle):
            return true
        case (.loading, .loading):
            return true
        case let (.loaded(lhsMessages), .loaded(rhsMessages)):
            return lhsMessages.map(\.id) == rhsMessages.map(\.id)
        case let (.error(lhsMessage), .error(rhsMessage)):
            return lhsMessage == rhsMessage
        default:
            return false
        }
    }
}

// MARK: - Messages View Model

/// ViewModel for messages list screen
@MainActor
@Observable
final class MessagesViewModel {
    // MARK: - Properties

    private(set) var state: MessagesState = .idle
    private(set) var unreadCount: Int = 0
    private(set) var isInteractionEnabled = true
    private(set) var isLoadingMore = false
    private(set) var hasMorePages = true

    // MARK: - Private Properties

    private let logger = Logger.app(category: "MessagesViewModel")
    private let apiClient: APIClient
    private let userId: String
    private var currentOffset = 0
    private let pageSize = 20
    private let webSocketManager: WebSocketManager

    // MARK: - Initialization

    /// Initializes the messages view model with required dependencies
    /// - Parameters:
    ///   - userId: The ID of the user whose messages to display
    ///   - apiClient: Client for making API requests
    ///   - webSocketManager: Manager for real-time WebSocket connections
    init(userId: String, apiClient: APIClient = .current, webSocketManager: WebSocketManager = WebSocketManager()) {
        self.userId = userId
        self.apiClient = apiClient
        self.webSocketManager = webSocketManager

        // Setup WebSocket message handler
        setupWebSocket()
    }

    // MARK: - WebSocket Setup

    /// Configures WebSocket connection and message handling for real-time updates
    private func setupWebSocket() {
        webSocketManager.onMessageReceived = { [weak self] message in
            guard let self = self else {
                return
            }

            Task { @MainActor in
                await self.handleWebSocketMessage(message)
            }
        }

        // Connect to WebSocket
        webSocketManager.connect(userId: userId)
    }

    /// Processes incoming WebSocket messages and updates UI accordingly
    /// - Parameter message: The WebSocket message received
    private func handleWebSocketMessage(_ message: WebSocketMessage) async {
        logger.info("Received WebSocket message of type: \(message.type)")

        switch message.type {
        case "new_message":
            // Reload messages when a new message is created
            await refresh()
            HapticFeedback.success()

        case "message_read":
            // Update unread count
            await fetchUnreadCount()

        case "message_deleted":
            // Reload messages
            await refresh()

        default:
            logger.debug("Unknown message type: \(message.type)")
        }
    }

    /// Cleanup WebSocket connection when view model is deallocated
    deinit {
        webSocketManager.disconnect()
    }

    // MARK: - Public Methods

    /// Loads initial messages and unread count for the current user
    func loadMessages() async {
        logger.info("Loading messages for user: \(self.userId)")

        state = .loading
        isInteractionEnabled = false
        currentOffset = 0

        await withTaskGroup(of: Void.self) { group in
            // Load messages
            group.addTask {
                await self.fetchMessages()
            }

            // Load unread count
            group.addTask {
                await self.fetchUnreadCount()
            }
        }

        isInteractionEnabled = true
    }

    /// Loads additional messages for pagination
    func loadMoreMessages() async {
        guard hasMorePages, !isLoadingMore, case .loaded(let currentMessages) = state else {
            return
        }

        logger.info("Loading more messages at offset: \(self.currentOffset)")
        isLoadingMore = true

        do {
            let response = try await apiClient.requestWithRetry(
                "users/\(userId)/messages",
                retryPolicy: .standard
            ) as ListResponse<MessageResponse>

            var allMessages = currentMessages
            allMessages.append(contentsOf: response.data)
            state = .loaded(allMessages)
            currentOffset += response.data.count
            hasMorePages = response.data.count >= pageSize

            logger.info("Loaded \(response.data.count) more messages, total: \(allMessages.count)")
        } catch {
            logger.error("Failed to load more messages: \(error.localizedDescription)")
        }

        isLoadingMore = false
    }

    /// Refreshes the messages list from the server
    func refresh() async {
        logger.info("Refreshing messages")
        HapticFeedback.light()
        await loadMessages()
    }

    /// Marks a specific message as read
    /// - Parameter messageId: The unique identifier of the message to mark as read
    func markAsRead(_ messageId: String) async {
        logger.debug("Marking message as read: \(messageId)")

        do {
            let _: [String: String] = try await apiClient.request(
                "messages/\(messageId)/read",
                method: .patch
            )

            // Reload messages and count
            await loadMessages()
            HapticFeedback.light()
        } catch {
            logger.error("Failed to mark message as read: \(error.localizedDescription)")
        }
    }

    // MARK: - Private Methods

    /// Fetches messages from the API with retry logic
    private nonisolated func fetchMessages() async {
        do {
            let response = try await apiClient.requestWithRetry(
                "users/\(userId)/messages",
                retryPolicy: .standard
            ) as ListResponse<MessageResponse>

            await MainActor.run {
                state = .loaded(response.data)
                currentOffset = response.data.count
                hasMorePages = response.data.count >= pageSize
                logger.info("Loaded \(response.data.count) messages")
            }
            HapticFeedback.success()
        } catch {
            logger.error("Failed to load messages: \(error.localizedDescription)")
            await MainActor.run {
                state = .error("Failed to load messages")
            }
            HapticFeedback.error()
        }
    }

    /// Fetches the unread message count from the API
    private nonisolated func fetchUnreadCount() async {
        do {
            let response = try await apiClient.request(
                "users/\(userId)/messages/unread-count"
            ) as UnreadCountResponse

            await MainActor.run {
                unreadCount = response.unreadCount
            }
            logger.debug("Unread count: \(response.unreadCount)")
        } catch {
            logger.error("Failed to load unread count: \(error.localizedDescription)")
        }
    }
}
