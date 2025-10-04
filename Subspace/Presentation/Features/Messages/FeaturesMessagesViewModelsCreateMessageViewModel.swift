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

enum MessageKindOption: String, CaseIterable, Sendable {
    case info = "Info"
    case warning = "Warning"
    case error = "Error"
    case success = "Success"

    var icon: String {
        switch self {
        case .info: return "info.circle.fill"
        case .warning: return "exclamationmark.triangle.fill"
        case .error: return "xmark.circle.fill"
        case .success: return "checkmark.circle.fill"
        }
    }

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

    var isValid: Bool {
        !content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var canSubmit: Bool {
        isValid && state != .creating
    }

    // MARK: - Initialization

    init(userId: String, apiClient: APIClient = .current) {
        self.userId = userId
        self.apiClient = apiClient
    }

    // MARK: - Public Methods

    /// Create a new message
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

    /// Reset form
    func reset() {
        content = ""
        selectedKind = .info
        state = .idle
    }
}
