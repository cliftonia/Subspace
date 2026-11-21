//
//  CreateMessageViewModel.swift
//  Subspace
//
//  Created by Clifton Baggerman on 03/10/2025.
//

import LCARSComponents
import Observation
import os
import SwiftUI

// MARK: - Message Kind Selection

/// Represents different types of messages that can be created
enum MessageKindOption: String, CaseIterable, Sendable {
    case normal = "Normal"
    case priority = "Priority"

    /// The kind sent to the API, which accepts info, warning, error and success
    var apiKind: String {
        switch self {
        case .normal: return "info"
        case .priority: return "error"
        }
    }

    /// Returns the LCARS color associated with this message kind
    var color: Color {
        switch self {
        case .normal: return .lcarViolet
        case .priority: return .lcarOrange
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
    var selectedKind: MessageKindOption = .normal
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
    func createMessage() async {
        guard canSubmit else {
            return
        }

        let logger = Logger.app(category: "CreateMessageViewModel")
        logger.info("Creating message")
        state = .creating
        HapticFeedback.light()

        do {
            let messageData: [String: Any] = [
                "userId": userId,
                "content": content.trimmingCharacters(in: .whitespacesAndNewlines),
                "kind": selectedKind.apiKind,
                "isRead": false
            ]

            let jsonData = try JSONSerialization.data(withJSONObject: messageData)

            _ = try await apiClient.request(
                "messages",
                method: .post,
                body: jsonData
            ) as MessageResponse

            state = .success
            HapticFeedback.success()
            logger.info("Message created successfully")
        } catch {
            logger.error("Failed to create message: \(error.localizedDescription)")
            state = .error("Failed to create message")
            HapticFeedback.error()
        }
    }

    /// Resets the form to its initial state
    func reset() {
        content = ""
        selectedKind = .normal
        state = .idle
    }
}
