//
//  LCARSMessagesViewIntegratedNew.swift
//  Subspace
//
//  Created by Clifton Baggerman on 05/10/2025.
//

import SwiftUI
import os

/// LCARS-themed messages view with sidebar navigation
struct LCARSMessagesViewIntegratedNew: View {

    // MARK: - Properties

    @State private var viewModel: MessagesViewModel
    @State private var showingCreateMessage = false
    @State private var selectedFilter: MessageFilter = .all

    private let logger = Logger.app(category: "LCARSMessagesViewIntegrated")
    private let userId: String

    // MARK: - Initialization

    init(userId: String = "user-1") {
        self.userId = userId
        self._viewModel = State(wrappedValue: MessagesViewModel(userId: userId))
    }

    // MARK: - Body

    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color.lcarBlack
                    .ignoresSafeArea()

                VStack(spacing: 10) {
                    // Top frame (small like ComponentLibrary)
                    topFrame
                        .frame(height: max(geo.size.height / 5, 100))

                    // Content area (large like ComponentLibrary)
                    contentArea
                        .frame(height: max(geo.size.height * 0.8 - 10, 100))
                }
            }
        }
        .ignoresSafeArea()
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    showingCreateMessage = true
                    HapticFeedback.light()
                } label: {
                    Image(systemName: "square.and.pencil")
                        .foregroundStyle(Color.lcarOrange)
                }
            }
        }
        .sheet(isPresented: $showingCreateMessage) {
            CreateMessageView(userId: userId)
        }
        .task {
            await viewModel.loadMessages()
        }
        .onAppear {
            logger.logUserAction("Viewed LCARS Messages")
        }
    }

    // MARK: - Top Frame

    private var topFrame: some View {
        GeometryReader { geo in
            ZStack {
                VStack(spacing: 5) {
                    selectedFilter.color
                    Color.lcarPink
                    Color.lcarViolet
                }
                .clipShape(RoundedRectangle(cornerRadius: 70))
                .overlay(alignment: .topTrailing) {
                    Color.lcarBlack
                        .clipShape(RoundedRectangle(cornerRadius: 35))
                        .frame(width: geo.size.width - 100, height: geo.size.height - 20)
                }
                .overlay(alignment: .topLeading) {
                    Color.lcarBlack
                        .frame(width: 100, height: 50)
                }
                .overlay(alignment: .topTrailing) {
                    Text(selectedFilter.headerTitle)
                        .font(.custom("HelveticaNeue-CondensedBold", size: 32))
                        .padding(.top, 50)
                        .padding(.trailing, 20)
                        .foregroundStyle(selectedFilter.color)
                        .scaleEffect(x: 0.7, anchor: .trailing)
                }
                .overlay(alignment: .leading) {
                    VStack(alignment: .trailing, spacing: 10) {
                        Text("LCARS \(randomDigits(5))")
                        Text(String(format: "%02d", selectedFilter.rawValue) + "-\(randomDigits(6))")
                    }
                    .font(.custom("HelveticaNeue-CondensedBold", size: 17))
                    .foregroundStyle(Color.lcarBlack)
                    .scaleEffect(x: 0.7, anchor: .trailing)
                    .frame(width: 90)
                }
            }
        }
    }

    // MARK: - Content Area

    private var contentArea: some View {
        HStack(spacing: 0) {
            // Left sidebar with filter buttons
            filterSidebar
                .frame(width: 100)
                .padding(.leading, 8)

            // Main content
            messageListContent
                .padding(.leading, 20)
        }
    }

    private var filterSidebar: some View {
        VStack(spacing: 8) {
            ForEach(MessageFilter.allCases) { filter in
                Button {
                    withAnimation(.spring(response: 0.3)) {
                        selectedFilter = filter
                    }
                    HapticFeedback.light()
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 30)
                            .fill(selectedFilter == filter ? Color.lcarOrange : filter.color)
                            .frame(height: 80)

                        VStack(spacing: 4) {
                            Text(filter.title)
                                .font(.custom("HelveticaNeue-CondensedBold", size: 11))
                                .foregroundStyle(Color.lcarBlack)
                                .lineLimit(1)
                                .minimumScaleFactor(0.7)
                                .frame(maxWidth: .infinity, alignment: .trailing)

                            Text(String(format: "%02d", filter.rawValue) + "-\(randomDigits(4))")
                                .font(.custom("HelveticaNeue-CondensedBold", size: 10))
                                .foregroundStyle(Color.lcarBlack)
                                .scaleEffect(x: 0.8, anchor: .trailing)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                        .padding(.horizontal, 8)
                        .padding(.trailing, 4)
                    }
                }
            }
            Spacer()
        }
    }

    // MARK: - Message List Content

    private var messageListContent: some View {
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
        }
    }

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
                    messageSkeletonRow
                }
            }

        case .loaded(let messages):
            let filteredMessages = filterMessages(messages)
            if filteredMessages.isEmpty {
                emptyState
            } else {
                LazyVStack(spacing: 12) {
                    ForEach(filteredMessages.prefix(10)) { message in
                        lcarMessageRow(message: message)
                    }
                }
            }

        case .error(let errorMessage):
            errorView(message: errorMessage)
        }
    }

    // MARK: - Message Row (LCARS Style)

    private func lcarMessageRow(message: MessageResponse) -> some View {
        Button {
            Task {
                await viewModel.markAsRead(message.id)
            }
            HapticFeedback.light()
        } label: {
            HStack(spacing: 0) {
                // Left accent bar
                RoundedRectangle(cornerRadius: 8)
                    .fill(messageColor(message.kind))
                    .frame(width: 8)

                VStack(alignment: .leading, spacing: 6) {
                    // Header row
                    HStack {
                        // Status indicator
                        Circle()
                            .fill(message.isRead ? Color.lcarWhite.opacity(0.3) : Color.lcarOrange)
                            .frame(width: 8, height: 8)

                        // Message type badge
                        Text(messageKind(message.kind).uppercased())
                            .font(.custom("HelveticaNeue-CondensedBold", size: 10))
                            .foregroundStyle(Color.lcarBlack)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(messageColor(message.kind))
                            )

                        Spacer()

                        // Timestamp code
                        Text("T-\(randomDigits(4))")
                            .font(.custom("HelveticaNeue-CondensedBold", size: 10))
                            .foregroundStyle(Color.lcarOrange.opacity(0.6))
                    }

                    // Message content
                    Text(message.content)
                        .font(.custom("HelveticaNeue", size: 13))
                        .foregroundStyle(message.isRead ? Color.lcarWhite.opacity(0.6) : Color.lcarWhite)
                        .lineLimit(2)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(12)
            }
            .frame(height: 70)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(message.isRead ? Color.clear : messageColor(message.kind).opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .strokeBorder(messageColor(message.kind).opacity(0.5), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(.plain)
    }

    // MARK: - Skeleton & Empty States

    private var messageSkeletonRow: some View {
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

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "tray.fill")
                .font(.system(size: 50))
                .foregroundStyle(Color.lcarViolet)

            Text("NO MESSAGES")
                .font(.custom("HelveticaNeue-CondensedBold", size: 16))
                .foregroundStyle(Color.lcarOrange)

            Text(selectedFilter.emptyMessage)
                .font(.system(size: 12))
                .foregroundStyle(Color.lcarWhite.opacity(0.6))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(40)
    }

    private func errorView(message: String) -> some View {
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

    private func messageKind(_ kind: String) -> String {
        kind.capitalized
    }

    private func messageColor(_ kind: String) -> Color {
        switch kind.lowercased() {
        case "error": return Color.lcarPlum
        case "warning": return Color.lcarTan
        case "success": return Color.lcarOrange
        default: return Color.lcarViolet
        }
    }

    private func randomDigits(_ count: Int) -> String {
        (1...count).map { _ in "\(Int.random(in: 0...9))" }.joined()
    }
}

// MARK: - Message Filter

enum MessageFilter: Int, CaseIterable, Identifiable {
    case all = 1
    case unread = 2
    case priority = 3
    case archived = 4

    var id: Int { rawValue }

    var title: String {
        switch self {
        case .all: return "ALL"
        case .unread: return "UNREAD"
        case .priority: return "PRIORITY"
        case .archived: return "ARCHIVE"
        }
    }

    var code: Int { rawValue }

    var headerTitle: String {
        switch self {
        case .all: return "ALL MESSAGES"
        case .unread: return "UNREAD MESSAGES"
        case .priority: return "PRIORITY MESSAGES"
        case .archived: return "ARCHIVED MESSAGES"
        }
    }

    var description: String {
        switch self {
        case .all: return "Displaying all communications from all sources"
        case .unread: return "Messages awaiting your attention"
        case .priority: return "High-priority alerts and critical notifications"
        case .archived: return "Previously archived communications"
        }
    }

    var emptyMessage: String {
        switch self {
        case .all: return "No communications received"
        case .unread: return "All messages have been read"
        case .priority: return "No priority alerts at this time"
        case .archived: return "No archived messages"
        }
    }

    var color: Color {
        switch self {
        case .all: return .lcarOrange
        case .unread: return .lcarViolet
        case .priority: return .lcarPlum
        case .archived: return .lcarTan
        }
    }
}

// MARK: - SidebarItemProtocol Conformance

extension MessageFilter: SidebarItemProtocol {}

// MARK: - Preview

#Preview {
    NavigationStack {
        LCARSMessagesViewIntegratedNew()
    }
}
