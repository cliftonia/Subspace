//
//  LCARSUsersViewIntegrated.swift
//  Subspace
//
//  Created by Clifton Baggerman on 04/10/2025.
//

import LCARSComponents
import os
import SwiftUI

/// Crew directory with search
struct LCARSUsersViewIntegrated: View {
    // MARK: - Properties

    @State private var viewModel = UsersViewModel()
    @State private var searchText = ""

    private let logger = Logger.app(category: "LCARSUsersViewIntegrated")

    // MARK: - Body

    var body: some View {
        VStack(spacing: 12) {
            LCARSTextField(placeholder: "SEARCH PERSONNEL", text: $searchText, color: .lcarTan)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()

            UsersContentView(viewModel: viewModel)
        }
        .task {
            await viewModel.loadUsers()
        }
        .onAppear {
            logger.logUserAction("Viewed LCARS Users")
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
