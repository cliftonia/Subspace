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

                ScrollView {
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

                        // Message Content
                        ShowcaseSection(title: "Content") {
                            VStack(alignment: .leading, spacing: 12) {
                                LCARSComponents.LCARSTextField(
                                    placeholder: "Enter your message...",
                                    text: $viewModel.content
                                )

                                // Character count
                                HStack {
                                    Spacer()
                                    Text("\(viewModel.content.count)")
                                        .font(.custom("HelveticaNeue-CondensedBold", size: 12))
                                        .foregroundStyle(Color.lcarOrange.opacity(0.6))
                                        .monospacedDigit()
                                }
                            }
                        }

                        // Action Buttons
                        HStack(spacing: 12) {
                            // Cancel Button
                            Button {
                                viewModel.reset()
                                onDismiss()
                                HapticFeedback.light()
                            } label: {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.lcarPlum)
                                    .frame(height: 56)
                                    .overlay(alignment: .center) {
                                        Text("CANCEL")
                                            .font(.custom("HelveticaNeue-CondensedBold", size: 18))
                                            .foregroundStyle(Color.lcarBlack)
                                    }
                            }
                            .buttonStyle(.plain)

                            // Send Button
                            Button {
                                Task {
                                    await viewModel.createMessage()
                                    if case .success = viewModel.state {
                                        HapticFeedback.success()
                                        onDismiss()
                                    }
                                }
                            } label: {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(viewModel.canSubmit ? Color.lcarOrange : Color.lcarWhite.opacity(0.2))
                                    .frame(height: 56)
                                    .overlay(alignment: .center) {
                                        if viewModel.state == .creating {
                                            HStack {
                                                ProgressView()
                                                    .tint(Color.lcarBlack)
                                                    .scaleEffect(0.8)
                                                Text("SENDING")
                                                    .font(.custom("HelveticaNeue-CondensedBold", size: 18))
                                                    .foregroundStyle(Color.lcarBlack)
                                            }
                                        } else {
                                            Text("SEND")
                                                .font(.custom("HelveticaNeue-CondensedBold", size: 18))
                                                .foregroundStyle(
                                                    viewModel.canSubmit ?
                                                        Color.lcarBlack :
                                                        Color.lcarWhite.opacity(0.4)
                                                )
                                        }
                                    }
                            }
                            .disabled(!viewModel.canSubmit)
                            .buttonStyle(.plain)
                        }
                        .padding(.top, 8)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 40)
                }
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
