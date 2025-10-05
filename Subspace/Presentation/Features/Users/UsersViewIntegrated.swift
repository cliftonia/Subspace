//
//  LCARSUsersViewIntegrated.swift
//  Subspace
//
//  Created by Clifton Baggerman on 04/10/2025.
//

import SwiftUI
import LCARSComponents
import os

/// LCARS-themed users view with integrated design
struct LCARSUsersViewIntegrated: View {

    // MARK: - Properties

    @State private var viewModel = UsersViewModel()
    @State private var searchText = ""

    private let logger = Logger.app(category: "LCARSUsersViewIntegrated")

    // MARK: - Body

    var body: some View {
        LCARSContentInFrame(
            topColors: [.lcarViolet, .lcarPlum],
            bottomColors: [.lcarTan, .lcarOrange, .lcarPink, .lcarViolet],
            topTitle: "PERSONNEL",
            bottomTitle: "DIRECTORY",
            topCode: "USR",
            bottomCode: "",
            bottomLabels: [("ACT", ""), ("DIR", ""), ("ADM", ""), ("GRP", "")],
            contentWidth: 280,
            contentHeight: 400
        ) {
            userListContent
        }
        .task {
            await viewModel.loadUsers()
        }
        .onAppear {
            logger.logUserAction("Viewed LCARS Users")
        }
    }

    // MARK: - Content

    private var userListContent: some View {
        VStack(spacing: 12) {
            UsersSearchBar(
                searchText: $searchText,
                onClear: {
                    searchText = ""
                    viewModel.clearSearch()
                }
            )

            UsersContentView(viewModel: viewModel)
        }
        .onChange(of: searchText) { _, newValue in
            viewModel.updateSearch(newValue)
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        LCARSUsersViewIntegrated()
    }
}
