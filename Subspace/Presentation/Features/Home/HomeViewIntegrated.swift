//
//  LCARSHomeViewIntegrated.swift
//  Subspace
//
//  Created by Clifton Baggerman on 04/10/2025.
//

import LCARSComponents
import os
import SwiftUI

/// LCARS-themed home screen with integrated design
struct LCARSHomeViewIntegrated: View {
    // MARK: - Properties

    @Environment(AppDependencies.self)
    private var dependencies
    @Environment(AuthViewModel.self)
    private var authViewModel
    @State private var viewModel = HomeViewModel()

    private let logger = Logger.app(category: "LCARSHomeViewIntegrated")

    // MARK: - Body

    var body: some View {
        LCARSContentInFrame(
            topColors: [.lcarPink, .lcarViolet],
            bottomColors: [.lcarPlum, .lcarPlum, .lcarOrange, .lcarTan],
            topTitle: "SUBSPACE \(LCARSUtilities.randomDigits(3))",
            bottomTitle: "COMMAND \(LCARSUtilities.randomDigits(3))",
            topCode: "02",
            bottomCode: "",
            bottomLabels: [("03", ""), ("04", ""), ("05", ""), ("06", "")],
            contentWidth: 300,
            contentHeight: 250
        ) {
            HomeQuickActionsView()
        }
        .task {
            await viewModel.loadHomeData(
                messageService: dependencies.messageService
            )
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    Task {
                        await authViewModel.logout()
                    }
                } label: {
                    Text("LOGOUT")
                        .font(.custom("HelveticaNeue-CondensedBold", size: 14))
                        .foregroundStyle(Color.lcarOrange)
                }
            }
        }
        .onAppear {
            logger.logUserAction("Viewed LCARS Home Screen")
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        LCARSHomeViewIntegrated()
            .environment(AppDependencies())
            .environment(AuthViewModel(authService: MockAuthService()))
    }
}
