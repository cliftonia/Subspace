//
//  MessagesView.swift
//  Subspace
//
//  Created by Clifton Baggerman on 25/10/2025.
//

import LCARSComponents
import os
import SwiftUI

/// Subspace communications: filtered messages and composing new ones
struct MessagesView: View {
    // MARK: - State

    @State private var viewModel: MessagesViewModel
    @State private var selectedFilter: MessageFilter = .all
    @State private var showingCreateMessage = false
    @State private var createMessageViewModel: CreateMessageViewModel

    private let logger = Logger.app(category: "MessagesView")

    // MARK: - Initialization

    init(userId: String) {
        self._viewModel = State(wrappedValue: MessagesViewModel(userId: userId))
        self._createMessageViewModel = State(wrappedValue: CreateMessageViewModel(userId: userId))
    }

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            filterRow

            ScrollView {
                messagesContent
                    .padding(.bottom, 16)
            }
            .scrollIndicators(.hidden)
            .refreshable {
                await viewModel.refresh()
            }

            Button("New Transmission") {
                showingCreateMessage = true
            }
            .buttonStyle(.lcars(.lcarOrange))
            .padding(.bottom, 8)
        }
        .task {
            await viewModel.loadMessages()
        }
        .onAppear {
            logger.logUserAction("Viewed Messages")
        }
        .sheet(isPresented: $showingCreateMessage) {
            CreateMessageView(viewModel: createMessageViewModel) {
                showingCreateMessage = false
                createMessageViewModel.reset()
                Task {
                    await viewModel.loadMessages()
                }
            }
        }
    }

    // MARK: - Filters

    private var filterRow: some View {
        LCARSWeightedRow(weights: [1, 1.3, 1.3, 1.3]) {
            ForEach(MessageFilter.allCases) { filter in
                Button(filter.title) {
                    selectedFilter = filter
                }
                .buttonStyle(.lcars(filter.color, form: .segment, isSelected: filter == selectedFilter))
            }
        }
        .frame(height: 48)
    }

    // MARK: - Messages

    @ViewBuilder private var messagesContent: some View {
        switch viewModel.state {
        case .idle, .loading:
            VStack(spacing: 8) {
                ForEach(0..<4, id: \.self) { _ in
                    MessageSkeletonRow()
                }
            }

        case .loaded(let messages):
            messagesList(messages.filter(selectedFilter.includes))

        case .error(let errorMessage):
            statusText(errorMessage, color: .lcarRed)
        }
    }

    @ViewBuilder
    private func messagesList(_ messages: [MessageResponse]) -> some View {
        if messages.isEmpty {
            statusText(selectedFilter.emptyMessage, color: .lcarViolet)
        } else {
            LazyVStack(spacing: 8) {
                ForEach(messages) { message in
                    MessageRow(
                        message: message,
                        onRead: {
                            Task {
                                await viewModel.markAsRead(message.id)
                            }
                        },
                        onArchive: {
                            Task {
                                await viewModel.archive(message.id)
                            }
                        }
                    )
                }
            }
        }
    }

    private func statusText(_ text: String, color: Color) -> some View {
        Text(text.uppercased())
            .font(.lcars(22))
            .foregroundStyle(color)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 16)
    }
}

// MARK: - Preview

#Preview {
    MessagesView(userId: "picard")
}
