//
//  LCARSMessagesViewIntegratedNew.swift
//  Subspace
//
//  Created by Clifton Baggerman on 05/10/2025.
//

import LCARSComponents
import os
import SwiftUI

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
        LCARSContentWithSidebar(
            topColors: [selectedFilter.color, .lcarPink, .lcarViolet],
            bottomColors: [],
            topTitle: selectedFilter.headerTitle,
            bottomTitle: "",
            topCode: String(format: "%02d", selectedFilter.rawValue),
            bottomCode: "",
            sidebarItems: MessageFilter.allCases,
            selectedItem: $selectedFilter
        ) { _ in
            MessagesContentView(viewModel: viewModel, selectedFilter: selectedFilter)
        }
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
}

// MARK: - Preview

#Preview {
    NavigationStack {
        LCARSMessagesViewIntegratedNew()
    }
}
