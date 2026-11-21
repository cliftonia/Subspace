//
//  LCARSHomeViewIntegrated.swift
//  Subspace
//
//  Created by Clifton Baggerman on 04/10/2025.
//

import LCARSComponents
import os
import SwiftUI

/// Operations overview shown when the console opens
struct LCARSHomeViewIntegrated: View {
    // MARK: - Properties

    let onOpen: (AppSection) -> Void

    @Environment(AppDependencies.self)
    private var dependencies
    @Environment(AuthViewModel.self)
    private var authViewModel
    @AppStorage(AppPreferences.redAlertKey)
    private var isRedAlert = false
    @State private var viewModel = HomeViewModel()

    private let logger = Logger.app(category: "LCARSHomeViewIntegrated")

    // MARK: - Body

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                LCARSDataCascade(seed: "operations")

                LCARSSectionHeader("Ship Status")

                VStack(spacing: 6) {
                    LCARSReadoutRow(label: "Stardate", value: Stardate.string(for: Date()), color: .lcarOrange)
                    LCARSReadoutRow(label: "Officer", value: officerName, color: .lcarViolet)
                    LCARSReadoutRow(label: "Condition", value: condition, color: isRedAlert ? .lcarAlert : .lcarTan)
                }

                LCARSSectionHeader("Latest Transmission", color: .lcarViolet)

                Text(latestTransmission)
                    .font(.lcarsBody(17))
                    .foregroundStyle(Color.lcarWhite)
                    .fixedSize(horizontal: false, vertical: true)

                Button("Open Comms") {
                    onOpen(.messages)
                }
                .buttonStyle(.lcars(.lcarViolet))
            }
            .padding(.bottom, 16)
        }
        .scrollIndicators(.hidden)
        .task {
            await viewModel.loadHomeData(
                messageService: dependencies.messageService
            )
        }
        .onAppear {
            logger.logUserAction("Viewed LCARS Home Screen")
        }
    }

    // MARK: - Display Values

    private var officerName: String {
        authViewModel.currentUser?.displayName ?? "Unknown"
    }

    private var condition: String {
        isRedAlert ? "Red Alert" : "All systems nominal"
    }

    private var latestTransmission: String {
        switch viewModel.state {
        case .idle, .loading:
            return "Receiving..."
        case .loaded(let message):
            return message
        case .error(let message):
            return message
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        LCARSHomeViewIntegrated { _ in }
            .environment(AppDependencies(userId: "preview-user-id"))
            .environment(AuthViewModel(authService: MockAuthService()))
    }
}
