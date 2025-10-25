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

    @State private var viewModel: MessagesViewModel
    @State private var selectedFilter: MessageFilter = .all
    @State private var showingCreateMessage = false
    @State private var createMessageViewModel: CreateMessageViewModel

    private let logger = Logger.app(category: "MessagesView")
    private let userId: String

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
                        Text("LCARS \(LCARSUtilities.randomDigits(5))")
                        Text(String(format: "%02d", selectedFilter.rawValue) + "-\(LCARSUtilities.randomDigits(6))")
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
            // Left sidebar with navigation
            VStack(spacing: 8) {
                ForEach(MessageFilter.allCases) { filter in
                    Button {
                        // Close create message view if open
                        if showingCreateMessage {
                            withAnimation(.spring(response: 0.3)) {
                                showingCreateMessage = false
                            }
                            createMessageViewModel.reset()
                        }

                        // Update selected filter
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
                                    .font(.custom("HelveticaNeue-CondensedBold", size: 16))
                                    .foregroundStyle(Color.lcarBlack)
                                    .minimumScaleFactor(0.6)

                                Text(String(format: "%02d", filter.rawValue))
                                    .font(.custom("HelveticaNeue-CondensedBold", size: 12))
                                    .foregroundStyle(Color.lcarBlack.opacity(0.6))
                            }
                            .scaleEffect(x: 0.7, anchor: .center)
                        }
                    }
                }

                // NEW message button
                Button {
                    withAnimation(.spring(response: 0.3)) {
                        showingCreateMessage = true
                    }
                    HapticFeedback.light()
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 30)
                            .fill(showingCreateMessage ? Color.lcarOrange : Color.lcarViolet)
                            .frame(height: 80)

                        VStack(spacing: 4) {
                            Text("NEW")
                                .font(.custom("HelveticaNeue-CondensedBold", size: 16))
                                .foregroundStyle(Color.lcarBlack)

                            Image(systemName: "square.and.pencil")
                                .font(.system(size: 14))
                                .foregroundStyle(Color.lcarBlack.opacity(0.6))
                        }
                        .scaleEffect(x: 0.7, anchor: .center)
                    }
                }

                Spacer()
            }
            .frame(width: 100)
            .padding(.leading, 8)

            // Main content
            contentForSelectedFilter
                .padding(.leading, 20)
        }
    }

    // MARK: - Filter Content

    @ViewBuilder
    private var contentForSelectedFilter: some View {
        if showingCreateMessage {
            createMessageContent()
        } else {
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
    }

    // MARK: - Messages Content

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

    // MARK: - Create Message Content

    @ViewBuilder
    private func createMessageContent() -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Title
                Text("NEW MESSAGE")
                    .font(.custom("HelveticaNeue-CondensedBold", size: 28))
                    .foregroundStyle(Color.lcarOrange)

                // Description
                Text("Compose a new message to send")
                    .font(.system(size: 14))
                    .foregroundStyle(Color.lcarWhite.opacity(0.8))

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
                        LCARSComponents.LCARSTextField(
                            placeholder: "Enter your message...",
                            text: $createMessageViewModel.content
                        )

                        // Character count
                        HStack {
                            Spacer()
                            Text("\(createMessageViewModel.content.count)")
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
                        withAnimation(.spring(response: 0.3)) {
                            showingCreateMessage = false
                        }
                        createMessageViewModel.reset()
                        HapticFeedback.light()
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
                            await createMessageViewModel.createMessage()
                            if case .success = createMessageViewModel.state {
                                HapticFeedback.success()
                                withAnimation(.spring(response: 0.3)) {
                                    showingCreateMessage = false
                                }
                                await viewModel.loadMessages()
                            }
                        }
                    } label: {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(createMessageViewModel.canSubmit ? Color.lcarOrange : Color.lcarWhite.opacity(0.2))
                            .frame(height: 50)
                            .overlay(alignment: .leading) {
                                if createMessageViewModel.state == .creating {
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
                                        .foregroundStyle(createMessageViewModel.canSubmit ? Color.lcarBlack : Color.lcarWhite.opacity(0.4))
                                        .padding(.leading, 20)
                                }
                            }
                    }
                    .disabled(!createMessageViewModel.canSubmit)
                    .buttonStyle(.plain)
                }
                .padding(.top, 8)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
        }
    }

    private func kindButton(_ kind: MessageKindOption) -> some View {
        Button {
            createMessageViewModel.selectedKind = kind
            HapticFeedback.selection()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(createMessageViewModel.selectedKind == kind ? kind.color : Color.white.opacity(0.05))
                    .frame(height: 60)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .strokeBorder(
                                createMessageViewModel.selectedKind == kind ? kind.color : Color.white.opacity(0.2),
                                lineWidth: createMessageViewModel.selectedKind == kind ? 2 : 1
                            )
                    )

                VStack(spacing: 4) {
                    Image(systemName: kind.icon)
                        .font(.system(size: 16))
                        .foregroundStyle(createMessageViewModel.selectedKind == kind ? Color.lcarBlack : kind.color)

                    Text(kind.rawValue.uppercased())
                        .font(.custom("HelveticaNeue-CondensedBold", size: 10))
                        .foregroundStyle(createMessageViewModel.selectedKind == kind ? Color.lcarBlack : Color.lcarWhite)
                }
            }
        }
        .buttonStyle(.plain)
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

// MARK: - Preview

#Preview {
    NavigationStack {
        MessagesView()
    }
}
