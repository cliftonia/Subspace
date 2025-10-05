//
//  CreateMessageView.swift
//  Subspace
//
//  Created by Clifton Baggerman on 03/10/2025.
//

import SwiftUI
import os

/// View for creating a new message
struct CreateMessageView: View {

    // MARK: - Properties

    @State private var viewModel: CreateMessageViewModel
    @Environment(\.dismiss) private var dismiss
    @FocusState private var isContentFocused: Bool

    private let logger = Logger.app(category: "CreateMessageView")

    // MARK: - Initialization

    /// Initializes the create message view
    /// - Parameter userId: The ID of the user creating the message
    init(userId: String) {
        self._viewModel = State(wrappedValue: CreateMessageViewModel(userId: userId))
    }

    // MARK: - Body

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    messageKindPicker
                    messageContentField
                    characterCount
                }
                .padding(20)
            }
            .navigationTitle("New Message")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        HapticFeedback.light()
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Send") {
                        Task {
                            await viewModel.createMessage()
                        }
                    }
                    .disabled(!viewModel.canSubmit)
                    .fontWeight(.semibold)
                }
            }
            .onAppear {
                isContentFocused = true
                logger.logUserAction("Opened Create Message")
            }
            .onChange(of: viewModel.state) { _, newState in
                if case .success = newState {
                    dismiss()
                }
            }
        }
    }
}

// MARK: - View Components

private extension CreateMessageView {

    /// Displays a picker for selecting the message kind
    var messageKindPicker: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Message Type")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)

            HStack(spacing: 12) {
                ForEach(MessageKindOption.allCases, id: \.self) { kind in
                    kindButton(kind)
                }
            }
        }
    }

    /// Creates a button for selecting a message kind
    /// - Parameter kind: The message kind option
    /// - Returns: A selectable button view for the message kind
    func kindButton(_ kind: MessageKindOption) -> some View {
        Button {
            viewModel.selectedKind = kind
            HapticFeedback.selection()
        } label: {
            VStack(spacing: 8) {
                Image(systemName: kind.icon)
                    .font(.title2)
                    .foregroundStyle(viewModel.selectedKind == kind ? kind.color : .secondary)

                Text(kind.rawValue)
                    .font(.caption)
                    .fontWeight(viewModel.selectedKind == kind ? .semibold : .regular)
                    .foregroundStyle(viewModel.selectedKind == kind ? kind.color : .secondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(
                viewModel.selectedKind == kind
                    ? kind.color.opacity(0.1)
                    : Color.gray.opacity(0.05)
            )
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        viewModel.selectedKind == kind ? kind.color : .clear,
                        lineWidth: 2
                    )
            )
        }
        .buttonStyle(.plain)
    }

    /// Displays the text editor for entering message content
    var messageContentField: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Message")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)

            TextEditor(text: $viewModel.content)
                .frame(minHeight: 120)
                .padding(12)
                .background(Color.gray.opacity(0.05))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                )
                .focused($isContentFocused)
                .disabled(viewModel.state == .creating)
        }
    }

    /// Displays the current character count of the message
    var characterCount: some View {
        HStack {
            Spacer()

            Text("\(viewModel.content.count)")
                .font(.caption)
                .foregroundStyle(.secondary)
                .monospacedDigit()
        }
    }
}

// MARK: - Preview

#Preview {
    CreateMessageView(userId: "user-1")
}
