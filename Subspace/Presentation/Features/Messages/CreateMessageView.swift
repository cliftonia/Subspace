//
//  CreateMessageView.swift
//  Subspace
//
//  Created by Clifton Baggerman on 25/10/2025.
//

import LCARSComponents
import SwiftUI

/// Sheet view for creating new messages
struct CreateMessageView: View {
    // MARK: - Properties

    @Bindable var viewModel: CreateMessageViewModel
    let onDismiss: () -> Void

    // MARK: - Body

    var body: some View {
        NavigationStack {
            ZStack {
                Color.lcarBlack
                    .ignoresSafeArea()

                VStack(alignment: .leading, spacing: 24) {
                    // Header
                    VStack(alignment: .leading, spacing: 8) {
                        Text("NEW MESSAGE")
                            .font(.custom("HelveticaNeue-CondensedBold", size: 32))
                            .foregroundStyle(Color.lcarOrange)

                        Text("Compose a new message to send")
                            .font(.system(size: 14))
                            .foregroundStyle(Color.lcarWhite.opacity(0.8))
                    }
                    .padding(.top, 20)

                    Divider()
                        .background(Color.lcarOrange.opacity(0.3))

                    // Message Type Selection
                    ShowcaseSection(title: "Message Type") {
                        HStack(spacing: 12) {
                            ForEach(MessageKindOption.allCases, id: \.self) { kind in
                                kindButton(kind)
                            }
                        }
                    }

                    // Message Content with integrated keyboard
                    ShowcaseSection(title: "Content") {
                        VStack(alignment: .leading, spacing: 12) {
                            // Character count
                            HStack {
                                Spacer()
                                Text("\(viewModel.content.count)")
                                    .font(.custom("HelveticaNeue-CondensedBold", size: 12))
                                    .foregroundStyle(Color.lcarOrange.opacity(0.6))
                                    .monospacedDigit()
                            }

                            LCARSComponents.LCARSTextField(
                                placeholder: "Enter your message...",
                                text: $viewModel.content,
                                onSend: {
                                    Task {
                                        await viewModel.createMessage()
                                        if case .success = viewModel.state {
                                            HapticFeedback.success()
                                            onDismiss()
                                        }
                                    }
                                },
                                onCancel: {
                                    viewModel.reset()
                                    onDismiss()
                                    HapticFeedback.light()
                                },
                                canSend: viewModel.canSubmit
                            )
                        }
                    }

                    Spacer()
                }
                .padding(.horizontal, 24)
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") {
                        viewModel.reset()
                        onDismiss()
                    }
                    .foregroundStyle(Color.lcarOrange)
                }
            }
        }
    }

    // MARK: - Kind Button

    private func kindButton(_ kind: MessageKindOption) -> some View {
        Button {
            viewModel.selectedKind = kind
            HapticFeedback.selection()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(viewModel.selectedKind == kind ? kind.color : Color.white.opacity(0.05))
                    .frame(height: 80)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .strokeBorder(
                                viewModel.selectedKind == kind ? kind.color : Color.white.opacity(0.2),
                                lineWidth: viewModel.selectedKind == kind ? 3 : 1
                            )
                    )

                VStack(spacing: 8) {
                    Image(systemName: kind.icon)
                        .font(.system(size: 24))
                        .foregroundStyle(viewModel.selectedKind == kind ? Color.lcarBlack : kind.color)

                    Text(kind.rawValue.uppercased())
                        .font(.custom("HelveticaNeue-CondensedBold", size: 12))
                        .foregroundStyle(viewModel.selectedKind == kind ? Color.lcarBlack : Color.lcarWhite)
                }
            }
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview

#Preview {
    CreateMessageView(
        viewModel: CreateMessageViewModel(userId: "user-1")
    ) {
        print("Dismissed")
    }
}
