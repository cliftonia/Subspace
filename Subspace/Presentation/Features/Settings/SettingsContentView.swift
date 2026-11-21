//
//  SettingsContentView.swift
//  Subspace
//
//  Created by Clifton Baggerman on 06/10/2025.
//

import LCARSComponents
import os
import SwiftUI

/// Settings content display view
struct SettingsContentView: View {
    // MARK: - Properties

    @Environment(AuthViewModel.self)
    private var authViewModel
    @AppStorage(LCARSAudio.enabledKey)
    private var isSoundEnabled = true
    @AppStorage(AppPreferences.redAlertKey)
    private var isRedAlert = false

    let dependencies: AppDependencies

    private let logger = Logger.app(category: "SettingsContentView")

    // MARK: - Body

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                LCARSSectionHeader("Console", color: .lcarPink)

                Toggle("Interface Sounds", isOn: $isSoundEnabled)
                    .toggleStyle(.lcars(.lcarOrange))

                Toggle("Red Alert", isOn: $isRedAlert)
                    .toggleStyle(.lcars(.lcarAlert))
                    .onChange(of: isRedAlert) { _, isActive in
                        if isActive {
                            LCARSAudio.shared.play(.alert)
                        }
                    }

                LCARSSectionHeader("System", color: .lcarViolet)

                VStack(spacing: 6) {
                    LCARSReadoutRow(
                        label: "Version",
                        value: dependencies.settingsService.getAppVersion(),
                        color: .lcarOrange
                    )
                    LCARSReadoutRow(label: "Network", value: networkName, color: .lcarViolet)
                }

                LCARSSectionHeader("Account", color: .lcarTan)

                if let user = authViewModel.currentUser {
                    NavigationLink(value: AppRoute.profile(userId: user.id)) {
                        Text("Personnel File")
                    }
                    .buttonStyle(.lcars(.lcarTan))
                }

                Button("Log Out") {
                    Task {
                        logger.logUserAction("Tapped LOGOUT")
                        await authViewModel.logout()
                    }
                }
                .buttonStyle(.lcars(.lcarRed))
            }
            .padding(.bottom, 16)
        }
        .scrollIndicators(.hidden)
    }

    // MARK: - Display Values

    private var networkName: String {
        AppConfiguration.usesLocalFleet ? "Local fleet" : AppConfiguration.apiBaseURL.host() ?? "Remote"
    }
}
