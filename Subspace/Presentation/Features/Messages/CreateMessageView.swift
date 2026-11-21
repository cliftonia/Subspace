//
//  CreateMessageView.swift
//  Subspace
//
//  Created by Clifton Baggerman on 25/10/2025.
//

import LCARSComponents
import SwiftUI

/// Composes a new transmission on the LCARS keyboard
struct CreateMessageView: View {
    // MARK: - Properties

    @Bindable var viewModel: CreateMessageViewModel
    let onDismiss: () -> Void

    @Environment(\.verticalSizeClass)
    private var verticalSizeClass

    // MARK: - Body

    var body: some View {
        Group {
            if verticalSizeClass == .compact {
                // Too short to stack: the message sits beside the keyboard instead of above it
                HStack(alignment: .top, spacing: 16) {
                    VStack(alignment: .leading, spacing: 12) {
                        composition
                        actions
                    }

                    LCARSKeyboard(text: $viewModel.content)
                }
            } else {
                VStack(alignment: .leading, spacing: 12) {
                    composition
                    LCARSKeyboard(text: $viewModel.content)
                    actions
                }
            }
        }
        .padding(16)
        .presentationBackground(Color.lcarBlack)
        .presentationDragIndicator(.hidden)
        .interactiveDismissDisabled()
    }

    // MARK: - Sections

    @ViewBuilder private var composition: some View {
        LCARSSectionHeader("New Transmission")

        kindSelector

        ScrollView {
            Text(viewModel.content.isEmpty ? "COMPOSE MESSAGE" : viewModel.content)
                .font(.lcarsBody(20))
                .foregroundStyle(viewModel.content.isEmpty ? Color.lcarOrange.opacity(0.6) : Color.lcarWhite)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .defaultScrollAnchor(.bottom)
        .accessibilityLabel("Message text")

        if case .error(let message) = viewModel.state {
            Text(message.uppercased())
                .font(.lcars(18))
                .foregroundStyle(Color.lcarRed)
        }
    }

    private var actions: some View {
        HStack(spacing: LCARSMetrics.gutter) {
            Button("Cancel", action: onDismiss)
                .buttonStyle(.lcars(.lcarRed))

            Button("Send", action: send)
                .buttonStyle(.lcars(.lcarOrange))
                .disabled(!viewModel.canSubmit)
        }
    }

    // MARK: - Kind Selector

    private var kindSelector: some View {
        HStack(spacing: LCARSMetrics.gutter) {
            ForEach(MessageKindOption.allCases, id: \.self) { kind in
                Button(kind.rawValue) {
                    viewModel.selectedKind = kind
                    HapticFeedback.selection()
                }
                .buttonStyle(.lcars(kind.color, form: .segment, isSelected: viewModel.selectedKind == kind))
            }
        }
    }

    // MARK: - Actions

    private func send() {
        Task {
            await viewModel.createMessage()
            if case .success = viewModel.state {
                LCARSAudio.shared.play(.confirm)
                onDismiss()
            }
        }
    }
}

// MARK: - Preview

#Preview {
    CreateMessageView(viewModel: CreateMessageViewModel(userId: "picard")) {}
}
