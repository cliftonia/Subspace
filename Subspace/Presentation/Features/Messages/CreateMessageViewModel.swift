//
//  CreateMessageViewModel.swift
//  Subspace
//
//  Created by Clifton Baggerman on 03/10/2025.
//

import SwiftUI
import Observation
import os

// MARK: - Message Kind Selection

/// Represents different types of messages that can be created
enum MessageKindOption: String, CaseIterable, Sendable {
    case info = "Info"
    case warning = "Warning"
    case error = "Error"
    case success = "Success"

    /// Returns the SF Symbol icon name for this message kind
    var icon: String {
        switch self {
        case .info: return "info.circle.fill"
        case .warning: return "exclamationmark.triangle.fill"
        case .error: return "xmark.circle.fill"
        case .success: return "checkmark.circle.fill"
        }
    }

    /// Returns the color associated with this message kind
    var color: Color {
        switch self {
        case .info: return .blue
        case .warning: return .orange
        case .error: return .red
        case .success: return .green
        }
    }
}

// MARK: - Create Message State

/// Represents the state of the message creation process
enum CreateMessageState: Equatable, Sendable {
    case idle
    case creating
    case success
    case error(String)
}

// MARK: - Create Message View Model

/// ViewModel for creating new messages
@MainActor
@Observable
final class CreateMessageViewModel {

    // MARK: - Properties

    var content: String = ""
    var selectedKind: MessageKindOption = .info
    private(set) var state: CreateMessageState = .idle

    // MARK: - Private Properties

    private let apiClient: APIClient
    private let userId: String

    // MARK: - Computed Properties

    /// Indicates whether the form contains valid data
    var isValid: Bool {
        !content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    /// Indicates whether the message can be submitted
    var canSubmit: Bool {
        isValid && state != .creating
    }

    // MARK: - Initialization

    /// Initializes the create message view model
    /// - Parameters:
    ///   - userId: The ID of the user creating the message
    ///   - apiClient: Client for making API requests
    init(userId: String, apiClient: APIClient = .current) {
        self.userId = userId
        self.apiClient = apiClient
    }

    // MARK: - Public Methods

    /// Creates a new message and submits it to the server
    nonisolated func createMessage() async {
        guard await canSubmit else { return }

        let logger = Logger.app(category: "CreateMessageViewModel")
        logger.info("Creating message")
        await MainActor.run { state = .creating }
        HapticFeedback.light()

        do {
            let messageData: [String: Any] = [
                "userId": await userId,
                "content": await content.trimmingCharacters(in: .whitespacesAndNewlines),
                "kind": await selectedKind.rawValue.lowercased(),
                "isRead": false
            ]

            let jsonData = try JSONSerialization.data(withJSONObject: messageData)

            let _ = try await apiClient.request(
                "messages",
                method: .post,
                body: jsonData
            ) as MessageResponse

            await MainActor.run { state = .success }
            HapticFeedback.success()
            logger.info("Message created successfully")

            // Reset form after short delay
            try? await Task.sleep(for: .seconds(1))
            await reset()

        } catch {
            logger.error("Failed to create message: \(error.localizedDescription)")
            await MainActor.run { state = .error("Failed to create message") }
            HapticFeedback.error()
        }
    }

    /// Resets the form to its initial state
    func reset() {
        content = ""
        selectedKind = .info
        state = .idle
    }
}
