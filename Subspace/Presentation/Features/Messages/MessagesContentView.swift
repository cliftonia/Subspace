//
//  MessagesContentView.swift
//  Subspace
//
//  Created by Clifton Baggerman on 06/10/2025.
//

import SwiftUI
import LCARSComponents

/// Messages list content view
struct MessagesContentView: View {

    // MARK: - Properties

    @Bindable var viewModel: MessagesViewModel
    let selectedFilter: MessageFilter

    // MARK: - Body

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Description
                Text(selectedFilter.description)
                    .font(.system(size: 14))
                    .foregroundStyle(Color.lcarWhite.opacity(0.8))
                    .lineLimit(3)
                    .multilineTextAlignment(.leading)

                Divider()
                    .background(Color.lcarOrange.opacity(0.3))
                    .padding(.vertical, 8)

                // Unread banner
                if viewModel.unreadCount > 0 {
                    unreadBanner
                }

                // Messages
                messagesContent
            }
            .padding(.bottom, 100)
        }
    }

    // MARK: - Content

    private var unreadBanner: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(Color.lcarOrange)
                .frame(width: 8, height: 8)

            Text("\(viewModel.unreadCount) UNREAD")
                .font(.custom("HelveticaNeue-CondensedBold", size: 12))
                .foregroundStyle(Color.lcarOrange)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .strokeBorder(Color.lcarOrange, lineWidth: 2)
        )
    }

    @ViewBuilder
    private var messagesContent: some View {
        switch viewModel.state {
        case .idle, .loading:
            VStack(spacing: 12) {
                ForEach(0..<3, id: \.self) { _ in
                    MessageSkeletonRow()
                }
            }

        case .loaded(let messages):
            let filteredMessages = filterMessages(messages)
            if filteredMessages.isEmpty {
                MessageEmptyState(filter: selectedFilter)
            } else {
                LazyVStack(spacing: 12) {
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

        case .error(let errorMessage):
            MessageErrorView(message: errorMessage)
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
        HStack(spacing: 0) {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.lcarWhite.opacity(0.2))
                .frame(width: 8)

            VStack(alignment: .leading, spacing: 8) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.lcarWhite.opacity(0.2))
                    .frame(width: 80, height: 12)

                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.lcarWhite.opacity(0.1))
                    .frame(height: 12)
            }
            .padding(12)
        }
        .frame(height: 70)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(Color.lcarWhite.opacity(0.2), lineWidth: 1)
        )
    }
}

struct MessageEmptyState: View {
    let filter: MessageFilter

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "tray.fill")
                .font(.system(size: 50))
                .foregroundStyle(Color.lcarViolet)

            Text("NO MESSAGES")
                .font(.custom("HelveticaNeue-CondensedBold", size: 16))
                .foregroundStyle(Color.lcarOrange)

            Text(filter.emptyMessage)
                .font(.system(size: 12))
                .foregroundStyle(Color.lcarWhite.opacity(0.6))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(40)
    }
}

struct MessageErrorView: View {
    let message: String

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 40))
                .foregroundStyle(Color.lcarPlum)

            Text("ERROR")
                .font(.custom("HelveticaNeue-CondensedBold", size: 16))
                .foregroundStyle(Color.lcarPlum)

            Text(message)
                .font(.system(size: 12))
                .foregroundStyle(Color.lcarWhite.opacity(0.6))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(40)
    }
}
