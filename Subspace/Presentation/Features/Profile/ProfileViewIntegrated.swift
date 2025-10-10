//
//  LCARSProfileViewIntegrated.swift
//  Subspace
//
//  Created by Clifton Baggerman on 04/10/2025.
//

import LCARSComponents
import os
import SwiftUI

/// LCARS-themed profile view with integrated design
struct LCARSProfileViewIntegrated: View {
    // MARK: - Properties

    let userId: String

    @Environment(AppDependencies.self) private var dependencies
    @State private var viewModel = ProfileViewModel()

    private let logger = Logger.app(category: "LCARSProfileViewIntegrated")

    // MARK: - Body

    var body: some View {
        LCARSContentInFrame(
            topColors: [.lcarTan, .lcarLightOrange],
            bottomColors: [.lcarOrange, .lcarViolet, .lcarPink, .lcarPlum],
            topTitle: "PERSONNEL FILE",
            bottomTitle: "RECORD \(LCARSUtilities.randomDigits(3))",
            topCode: "PFL",
            bottomCode: "",
            bottomLabels: [("BIO", ""), ("SEC", ""), ("LOG", ""), ("ACT", "")],
            contentWidth: 280,
            contentHeight: 400
        ) {
            profileContent
        }
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

    @ViewBuilder
    private var profileContent: some View {
        switch viewModel.state {
        case .idle, .loading:
            ProfileLoadingView()

        case .loaded(let user):
            ProfileContentView(user: user)

        case .error(let message):
            ProfileErrorView(message: message)
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        LCARSProfileViewIntegrated(userId: "user-1")
            .environment(AppDependencies())
    }
}
