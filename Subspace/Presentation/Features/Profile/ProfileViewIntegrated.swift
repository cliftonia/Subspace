//
//  LCARSProfileViewIntegrated.swift
//  Subspace
//
//  Created by Clifton Baggerman on 04/10/2025.
//

import LCARSComponents
import os
import SwiftUI

/// A crew member's personnel file
struct LCARSProfileViewIntegrated: View {
    // MARK: - Properties

    let userId: String
    let onOpenComms: () -> Void

    @Environment(AppDependencies.self)
    private var dependencies
    @Environment(\.dismiss)
    private var dismiss
    @State private var viewModel = ProfileViewModel()

    private let logger = Logger.app(category: "LCARSProfileViewIntegrated")

    // MARK: - Body

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                profileContent

                Button("Return") {
                    dismiss()
                }
                .buttonStyle(.lcars(.lcarViolet))
            }
            .padding(.bottom, 16)
        }
        .scrollIndicators(.hidden)
        .toolbar(.hidden, for: .navigationBar)
        .task {
            await viewModel.loadProfile(
                userId: userId,
                userService: dependencies.userService
            )
        }
        .onAppear {
            logger.logUserAction("Viewed LCARS Profile", context: userId)
        }
    }

    // MARK: - Profile Content

    @ViewBuilder private var profileContent: some View {
        switch viewModel.state {
        case .idle, .loading:
            ProfileLoadingView()

        case .loaded(let user):
            ProfileContentView(user: user, onOpenComms: onOpenComms)

        case .error(let message):
            ProfileErrorView(message: message)
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        LCARSProfileViewIntegrated(userId: "picard") {}
            .environment(AppDependencies(userId: "picard"))
    }
}
