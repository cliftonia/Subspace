//
//  MessagesContentView.swift
//  Subspace
//
//  Created by Clifton Baggerman on 06/10/2025.
//

import LCARSComponents
import SwiftUI

/// Messages content panel matching ComponentShowcaseView layout
struct MessagesContentView: View {
    // MARK: - Properties

    @Bindable var viewModel: MessagesViewModel
    let selectedFilter: MessageFilter

    // MARK: - Body

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Title
                Text(selectedFilter.title)
                    .font(.custom("HelveticaNeue-CondensedBold", size: 28))
                    .foregroundStyle(Color.lcarOrange)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)

                // Description
                Text(selectedFilter.description)
                    .font(.system(size: 14))
                    .foregroundStyle(Color.lcarWhite.opacity(0.8))
                    .lineLimit(3)
                    .multilineTextAlignment(.leading)

                Divider()
                    .background(Color.lcarOrange.opacity(0.3))
                    .padding(.vertical, 8)

                // Content
                messagesContent()
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
        }
    }

    // MARK: - Content

    @ViewBuilder
    private func messagesContent() -> some View {
        switch viewModel.state {
        case .idle, .loading:
            ShowcaseSection(title: "Loading") {
                VStack(spacing: 12) {
                    ForEach(0..<3, id: \.self) { _ in
                        MessageSkeletonRow()
                    }
                }
            }

        case .loaded(let messages):
            let filteredMessages = filterMessages(messages)

            if viewModel.unreadCount > 0 {
                ShowcaseSection(title: "Status") {
                    HStack(spacing: 12) {
                        Circle()
                            .fill(Color.lcarOrange)
                            .frame(width: 12, height: 12)

                        VStack(alignment: .leading, spacing: 4) {
                            Text("UNREAD MESSAGES")
                                .font(.custom("HelveticaNeue-CondensedBold", size: 14))
                                .foregroundStyle(Color.lcarOrange)

                            Text("\(viewModel.unreadCount) message\(viewModel.unreadCount == 1 ? "" : "s") require attention")
                                .font(.system(size: 12))
                                .foregroundStyle(Color.lcarWhite.opacity(0.6))
                        }

                        Spacer()
                    }
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .strokeBorder(Color.lcarOrange, lineWidth: 2)
                    )
                }
            }

            if filteredMessages.isEmpty {
                ShowcaseSection(title: "Status") {
                    VStack(spacing: 16) {
                        Image(systemName: "tray.fill")
                            .font(.system(size: 40))
                            .foregroundStyle(Color.lcarViolet)

                        VStack(spacing: 8) {
                            Text("NO MESSAGES")
                                .font(.custom("HelveticaNeue-CondensedBold", size: 16))
                                .foregroundStyle(Color.lcarOrange)

                            Text(selectedFilter.emptyMessage)
                                .font(.system(size: 12))
                                .foregroundStyle(Color.lcarWhite.opacity(0.6))
                                .multilineTextAlignment(.center)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 40)
                }
            } else {
                ShowcaseSection(title: selectedFilter.sectionTitle) {
                    VStack(spacing: 12) {
                        ForEach(filteredMessages.prefix(10)) { message in
                            MessageRow(message: message) {
                                Task {
                                    await viewModel.markAsRead(message.id)
                                }
                                HapticFeedback.light()
                            }
                        }
                    }
                }

                if messages.count > 10 {
                    ShowcaseSection(title: "Info") {
                        Text("Showing 10 of \(messages.count) messages")
                            .font(.system(size: 12))
                            .foregroundStyle(Color.lcarWhite.opacity(0.6))
                    }
                }
            }

        case .error(let errorMessage):
            ShowcaseSection(title: "Error") {
                VStack(spacing: 16) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 40))
                        .foregroundStyle(Color.lcarPlum)

                    VStack(spacing: 8) {
                        Text("ERROR")
                            .font(.custom("HelveticaNeue-CondensedBold", size: 16))
                            .foregroundStyle(Color.lcarPlum)

                        Text(errorMessage)
                            .font(.system(size: 12))
                            .foregroundStyle(Color.lcarWhite.opacity(0.6))
                            .multilineTextAlignment(.center)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 40)
            }
        }
    }

    // MARK: - Helpers

    /// Filters messages based on the selected filter criterion
    private func filterMessages(_ messages: [MessageResponse]) -> [MessageResponse] {
        switch selectedFilter {
        case .all:
            return messages
        case .unread:
            return messages.filter { !$0.isRead }
        case .priority:
            return messages.filter { $0.kind.lowercased() == "error" }
        case .archived:
            return []
        }
    }
}

// MARK: - Supporting Views

struct MessageSkeletonRow: View {
    var body: some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.lcarViolet.opacity(0.3))
                .frame(width: 60, height: 60)

            VStack(alignment: .leading, spacing: 6) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.lcarWhite.opacity(0.2))
                    .frame(width: 120, height: 12)

                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.lcarWhite.opacity(0.1))
                    .frame(height: 10)

                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.lcarWhite.opacity(0.1))
                    .frame(width: 180, height: 10)
            }

            Spacer()
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(Color.lcarWhite.opacity(0.2), lineWidth: 1)
        )
    }
}
