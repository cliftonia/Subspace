//
//  CreateMessageView.swift
//  Subspace
//
//  Created by Clifton Baggerman on 03/10/2025.
//

import LCARSComponents
import os
import SwiftUI

/// LCARS-styled view for creating a new message
struct CreateMessageView: View {
    // MARK: - Properties

    @State private var viewModel: CreateMessageViewModel
    @Environment(\.dismiss) private var dismiss
    @FocusState private var isContentFocused: Bool

    private let logger = Logger.app(category: "CreateMessageView")

    // MARK: - Initialization

    init(userId: String) {
        self._viewModel = State(wrappedValue: CreateMessageViewModel(userId: userId))
    }

    // MARK: - Body

    var body: some View {
        LCARSContentInFrame(
            topColors: [.lcarOrange, .lcarPink, .lcarViolet],
            bottomColors: [.lcarTan, .lcarPlum, .lcarViolet],
            topTitle: "NEW MESSAGE",
            bottomTitle: "COMPOSE",
            topCode: "99",
            bottomCode: "00",
            bottomLabels: [
                ("MSG", "001"),
                ("SYS", "002"),
                ("COM", "003")
            ],
            contentWidth: 340,
            contentHeight: 500
        ) {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Title
                    Text("COMPOSE MESSAGE")
                        .font(.custom("HelveticaNeue-CondensedBold", size: 28))
                        .foregroundStyle(Color.lcarOrange)

                    Divider()
                        .background(Color.lcarOrange.opacity(0.3))
                        .padding(.vertical, 8)

                    // Message Type Selection
                    ShowcaseSection(title: "Message Type") {
                        HStack(spacing: 8) {
                            ForEach(MessageKindOption.allCases, id: \.self) { kind in
                                kindButton(kind)
                            }
                        }
                    }

                    // Message Content
                    ShowcaseSection(title: "Content") {
                        VStack(alignment: .leading, spacing: 12) {
                            ZStack(alignment: .topLeading) {
                                // Background
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.white.opacity(0.05))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .strokeBorder(
                                                isContentFocused ? Color.lcarOrange : Color.white.opacity(0.2),
                                                lineWidth: 2
                                            )
                                    )
                                    .frame(height: 140)

                                // Text Editor
                                TextEditor(text: $viewModel.content)
                                    .scrollContentBackground(.hidden)
                                    .background(Color.clear)
                                    .foregroundStyle(Color.lcarWhite)
                                    .font(.custom("HelveticaNeue", size: 14))
                                    .padding(12)
                                    .frame(height: 140)
                                    .focused($isContentFocused)
                                    .disabled(viewModel.state == .creating)
                            }

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
                            HapticFeedback.light()
                            dismiss()
                        } label: {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.lcarPlum)
                                .frame(height: 50)
                                .overlay(alignment: .leading) {
                                    Text("CANCEL")
                                        .font(.custom("HelveticaNeue-CondensedBold", size: 17))
                                        .foregroundStyle(Color.lcarBlack)
                                        .padding(.leading, 20)
                                }
                        }
                        .buttonStyle(.plain)

                        // Send Button
                        Button {
                            Task {
                                await viewModel.createMessage()
                            }
                        } label: {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(viewModel.canSubmit ? Color.lcarOrange : Color.lcarWhite.opacity(0.2))
                                .frame(height: 50)
                                .overlay(alignment: .leading) {
                                    if viewModel.state == .creating {
                                        HStack {
                                            ProgressView()
                                                .tint(Color.lcarBlack)
                                                .scaleEffect(0.8)
                                            Text("SENDING")
                                                .font(.custom("HelveticaNeue-CondensedBold", size: 17))
                                                .foregroundStyle(Color.lcarBlack)
                                        }
                                        .padding(.leading, 20)
                                    } else {
                                        Text("SEND")
                                            .font(.custom("HelveticaNeue-CondensedBold", size: 17))
                                            .foregroundStyle(viewModel.canSubmit ? Color.lcarBlack : Color.lcarWhite.opacity(0.4))
                                            .padding(.leading, 20)
                                    }
                                }
                        }
                        .disabled(!viewModel.canSubmit)
                        .buttonStyle(.plain)
                    }
                    .padding(.top, 8)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
            }
        }
        .onAppear {
            isContentFocused = true
            logger.logUserAction("Opened Create Message")
        }
        .onChange(of: viewModel.state) { _, newState in
            if case .success = newState {
                HapticFeedback.success()
                dismiss()
            }
        }
    }

    // MARK: - Components

    private func kindButton(_ kind: MessageKindOption) -> some View {
        Button {
            viewModel.selectedKind = kind
            HapticFeedback.selection()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(viewModel.selectedKind == kind ? kind.color : Color.white.opacity(0.05))
                    .frame(height: 60)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .strokeBorder(
                                viewModel.selectedKind == kind ? kind.color : Color.white.opacity(0.2),
                                lineWidth: viewModel.selectedKind == kind ? 2 : 1
                            )
                    )

                VStack(spacing: 4) {
                    Image(systemName: kind.icon)
                        .font(.system(size: 16))
                        .foregroundStyle(viewModel.selectedKind == kind ? Color.lcarBlack : kind.color)

                    Text(kind.rawValue.uppercased())
                        .font(.custom("HelveticaNeue-CondensedBold", size: 10))
                        .foregroundStyle(viewModel.selectedKind == kind ? Color.lcarBlack : Color.lcarWhite)
                }
            }
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview

#Preview {
    CreateMessageView(userId: "user-1")
}
