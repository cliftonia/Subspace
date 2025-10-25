//
//  MessagesView.swift
//  Subspace
//
//  Created by Clifton Baggerman on 25/10/2025.
//

import LCARSComponents
import os
import SwiftUI

/// LCARS-themed messages view matching ComponentShowcaseView layout
struct MessagesView: View {
    // MARK: - State

    @State var viewModel: MessagesViewModel
    @State var selectedFilter: MessageFilter = .all
    @State var showingCreateMessage = false
    @State var createMessageViewModel: CreateMessageViewModel

    let logger = Logger.app(category: "MessagesView")
    let userId: String

    // MARK: - Initialization

    init(userId: String = "user-1") {
        self.userId = userId
        self._viewModel = State(wrappedValue: MessagesViewModel(userId: userId))
        self._createMessageViewModel = State(wrappedValue: CreateMessageViewModel(userId: userId))
    }

    // MARK: - Body

    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color.lcarBlack
                    .ignoresSafeArea()

                VStack(spacing: 10) {
                    // Top frame
                    topFrame
                        .frame(height: max(geo.size.height / 5, 100))

                    // Content area
                    contentArea
                        .frame(height: max(geo.size.height * 0.8 - 10, 100))
                }
            }
        }
        .ignoresSafeArea()
        .task {
            await viewModel.loadMessages()
        }
        .onAppear {
            logger.logUserAction("Viewed Messages")
        }
        .sheet(isPresented: $showingCreateMessage) {
            CreateMessageView(viewModel: createMessageViewModel) {
                showingCreateMessage = false
                Task {
                    await viewModel.loadMessages()
                }
            }
        }
    }

    // MARK: - Messages Content

    @ViewBuilder
    func messagesContent() -> some View {
        switch viewModel.state {
        case .idle, .loading:
            loadingView

        case .loaded(let messages):
            let filteredMessages = filterMessages(messages)
            messagesLoadedContent(filteredMessages: filteredMessages, totalCount: messages.count)

        case .error(let errorMessage):
            errorView(errorMessage: errorMessage)
        }
    }

    private var loadingView: some View {
        ShowcaseSection(title: "Loading") {
            VStack(spacing: 12) {
                ForEach(0..<3, id: \.self) { _ in
                    MessageSkeletonRow()
                }
            }
        }
    }

    @ViewBuilder
    private func messagesLoadedContent(filteredMessages: [MessageResponse], totalCount: Int) -> some View {
        if viewModel.unreadCount > 0 {
            unreadStatusBanner
        }

        if filteredMessages.isEmpty {
            emptyStateView
        } else {
            messagesList(filteredMessages)

            if totalCount > 10 {
                messagesCountInfo(totalCount: totalCount)
            }
        }
    }

    private var unreadStatusBanner: some View {
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

    private var emptyStateView: some View {
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
    }

    private func messagesList(_ messages: [MessageResponse]) -> some View {
        ShowcaseSection(title: selectedFilter.sectionTitle) {
            VStack(spacing: 12) {
                ForEach(messages.prefix(10)) { message in
                    MessageRow(message: message) {
                        Task {
                            await viewModel.markAsRead(message.id)
                        }
                        HapticFeedback.light()
                    }
                }
            }
        }
    }

    private func messagesCountInfo(totalCount: Int) -> some View {
        ShowcaseSection(title: "Info") {
            Text("Showing 10 of \(totalCount) messages")
                .font(.system(size: 12))
                .foregroundStyle(Color.lcarWhite.opacity(0.6))
        }
    }

    private func errorView(errorMessage: String) -> some View {
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

    // MARK: - Helpers

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

// MARK: - Preview

#Preview {
    NavigationStack {
        MessagesView()
    }
}
