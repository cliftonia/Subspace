//
//  LCARSMessagesViewIntegrated.swift
//  Subspace
//
//  Created by Clifton Baggerman on 04/10/2025.
//

import SwiftUI
import os

/// LCARS-themed messages view with integrated design
struct LCARSMessagesViewIntegrated: View {

    // MARK: - Properties

    @State private var viewModel: MessagesViewModel
    @State private var showingCreateMessage = false

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
                    // Top frame
                    topFrame
                        .frame(height: geo.size.height / 3)

                    // Bottom frame
                    bottomFrame
                        .frame(height: geo.size.height * (2/3) - 10)
                }

                // Message list content
                messageListContent
                    .offset(x: 50, y: 60)
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
                    Color.lcarOrange
                    Color.lcarPink
                }
                .cornerRadius(70, corners: .bottomLeft)
                .overlay(alignment: .topTrailing) {
                    Color.lcarBlack
                        .cornerRadius(35, corners: .bottomLeft)
                        .frame(width: geo.size.width - 100, height: geo.size.height - 20)
                }
                .overlay(alignment: .topLeading) {
                    Color.lcarBlack
                        .frame(width: 100, height: 50)
                }
                .overlay(alignment: .bottomTrailing) {
                    ZStack {
                        Color.lcarBlack
                        HStack(spacing: 5) {
                            Color.lcarViolet
                                .frame(width: 20)
                                .padding(.leading, 5)
                            Color.lcarPlum
                                .frame(width: 50)
                            Color.lcarOrange
                            Color.lcarTan
                                .frame(width: 20)
                        }
                    }
                    .frame(width: 200, height: 20)
                }
                .overlay(alignment: .leading) {
                    VStack(alignment: .trailing, spacing: 15) {
                        Text("LCARS \(randomDigits(5))")
                        Text("MSG-\(randomDigits(6))")
                    }
                    .font(.custom("HelveticaNeue-CondensedBold", size: 17))
                    .foregroundStyle(Color.lcarBlack)
                    .scaleEffect(x: 0.7, anchor: .trailing)
                    .frame(width: 90)
                }
                .overlay(alignment: .topTrailing) {
                    Text("COMMUNICATIONS")
                        .font(.custom("HelveticaNeue-CondensedBold", size: 35))
                        .padding(.top, 45)
                        .foregroundStyle(Color.lcarOrange)
                        .scaleEffect(x: 0.7, anchor: .trailing)
                }
                .overlay(alignment: .trailing) {
                    messageStatsGrid
                        .padding(.top, 40)
                }
            }
        }
    }

    private var messageStatsGrid: some View {
        Grid(alignment: .trailing) {
            ForEach(0..<7) { row in
                GridRow {
                    ForEach(0..<5) { _ in
                        Text(randomDigits(Int.random(in: 1...6)))
                            .foregroundStyle((row == 2 || row == 5) ? Color.lcarWhite : Color.lcarOrange)
                    }
                }
            }
        }
        .font(.custom("HelveticaNeue-CondensedBold", size: 17))
    }

    // MARK: - Bottom Frame

    private var bottomFrame: some View {
        GeometryReader { geo in
            ZStack {
                VStack(alignment: .leading, spacing: 5) {
                    Color.lcarViolet
                        .frame(height: 100)
                        .overlay(alignment: .bottomLeading) {
                            commonLabel(prefix: "RCV")
                                .padding(.bottom, 5)
                        }
                    Color.lcarPlum
                        .frame(height: 200)
                        .overlay(alignment: .bottomLeading) {
                            commonLabel(prefix: "SND")
                                .padding(.bottom, 5)
                        }
                    Color.lcarTan
                        .frame(height: 50)
                        .overlay(alignment: .leading) {
                            commonLabel(prefix: "ARC")
                        }
                    Color.lcarLightOrange
                        .overlay(alignment: .topLeading) {
                            commonLabel(prefix: "SYS")
                                .padding(.top, 5)
                        }
                }
                .cornerRadius(70, corners: .topLeft)
                .overlay(alignment: .bottomTrailing) {
                    Color.lcarBlack
                        .cornerRadius(35, corners: .topLeft)
                        .frame(width: geo.size.width - 100, height: geo.size.height - 20)
                }
                .overlay(alignment: .bottomLeading) {
                    Color.lcarBlack
                        .frame(width: 100, height: 50)
                }
                .overlay(alignment: .topTrailing) {
                    ZStack {
                        Color.lcarBlack
                        HStack(alignment: .top, spacing: 5) {
                            Color.lcarOrange
                                .frame(width: 20)
                                .padding(.leading, 5)
                            Color.lcarPink
                                .frame(width: 50, height: 10)
                            Color.lcarViolet
                            Color.lcarPlum
                                .frame(width: 20)
                        }
                    }
                    .frame(width: 200, height: 20)
                }
                .overlay(alignment: .bottomTrailing) {
                    Text("MESSAGE LOG")
                        .font(.custom("HelveticaNeue-CondensedBold", size: 35))
                        .padding(.bottom, 45)
                        .foregroundStyle(Color.lcarOrange)
                        .scaleEffect(x: 0.7, anchor: .trailing)
                }
            }
        }
    }

    private func commonLabel(prefix: String) -> some View {
        HStack {
            Spacer()
            Text("\(prefix)-\(randomDigits(4))")
                .font(.custom("HelveticaNeue-CondensedBold", size: 17))
                .foregroundStyle(Color.lcarBlack)
        }
        .frame(width: 90)
        .scaleEffect(x: 0.7, anchor: .trailing)
    }

    // MARK: - Message List Content

    private var messageListContent: some View {
        VStack(spacing: 12) {
            if viewModel.unreadCount > 0 {
                unreadBanner
            }

            ScrollView {
                messagesContent
            }
            .frame(width: 280, height: 400)
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
        .padding(8)
        .frame(width: 280)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder(Color.lcarOrange, lineWidth: 2)
        )
    }

    @ViewBuilder
    private var messagesContent: some View {
        switch viewModel.state {
        case .idle, .loading:
            VStack(spacing: 8) {
                ForEach(0..<3, id: \.self) { _ in
                    messageSkeletonRow
                }
            }

        case .loaded(let messages):
            if messages.isEmpty {
                emptyState
            } else {
                LazyVStack(spacing: 8) {
                    ForEach(messages.prefix(10), id: \.id) { message in
                        compactMessageRow(message: message)
                    }
                }
            }

        case .error(let errorMessage):
            errorView(message: errorMessage)
        }
    }

    private func compactMessageRow(message: MessageResponse) -> some View {
        Button {
            Task {
                await viewModel.markAsRead(message.id)
            }
        } label: {
            HStack(spacing: 8) {
                Circle()
                    .fill(message.isRead ? Color.lcarWhite.opacity(0.3) : Color.lcarOrange)
                    .frame(width: 6, height: 6)

                Text(message.content)
                    .font(.custom("HelveticaNeue", size: 12))
                    .foregroundStyle(message.isRead ? Color.lcarWhite.opacity(0.6) : Color.lcarWhite)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Text(messageKind(message.kind).uppercased().prefix(3))
                    .font(.custom("HelveticaNeue-CondensedBold", size: 10))
                    .foregroundStyle(messageColor(message.kind))
            }
            .padding(8)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(message.isRead ? Color.clear : Color.lcarOrange.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .strokeBorder(messageColor(message.kind), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(.plain)
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

    private var messageSkeletonRow: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(Color.lcarWhite.opacity(0.2))
                .frame(width: 6, height: 6)

            RoundedRectangle(cornerRadius: 4)
                .fill(Color.lcarWhite.opacity(0.2))
                .frame(height: 12)
        }
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder(Color.lcarWhite.opacity(0.2), lineWidth: 1)
        )
    }

    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "tray.fill")
                .font(.system(size: 40))
                .foregroundStyle(Color.lcarViolet)

            Text("NO MESSAGES")
                .font(.custom("HelveticaNeue-CondensedBold", size: 14))
                .foregroundStyle(Color.lcarOrange)
        }
        .frame(maxWidth: .infinity)
        .padding(40)
    }

    private func errorView(message: String) -> some View {
        VStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 30))
                .foregroundStyle(Color.lcarPlum)

            Text("ERROR")
                .font(.custom("HelveticaNeue-CondensedBold", size: 14))
                .foregroundStyle(Color.lcarPlum)
        }
        .frame(maxWidth: .infinity)
        .padding(40)
    }

    private func randomDigits(_ count: Int) -> String {
        (1...count).map { _ in "\(Int.random(in: 0...9))" }.joined()
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        LCARSMessagesViewIntegrated()
    }
}
