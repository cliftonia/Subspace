//
//  AppRootView.swift
//  Subspace
//
//  Created by Clifton Baggerman on 03/10/2025.
//

import LCARSComponents
import SwiftUI

/// The console: one permanent LCARS frame, with each section shown inside it
struct AppRootView: View {
    // MARK: - Properties

    @Environment(AuthViewModel.self)
    private var authViewModel
    @AppStorage(AppPreferences.redAlertKey)
    private var isRedAlert = false
    @State private var section: AppSection = .home
    @State private var navigationPath = NavigationPath()
    @State private var dependencies: AppDependencies?

    // MARK: - Body

    var body: some View {
        LCARSConsole(header: consoleHeader) {
            ForEach(AppSection.allCases) { item in
                Button(item.buttonTitle) {
                    select(item)
                }
                .buttonStyle(.lcars(item.color, form: .segment, isSelected: item == section))
            }
        } content: {
            if let dependencies = dependencies {
                NavigationStack(path: $navigationPath) {
                    sectionContent
                        .toolbar(.hidden, for: .navigationBar)
                        .navigationDestination(for: AppRoute.self) { route in
                            routeDestination(for: route)
                        }
                }
                .environment(dependencies)
                .environment(authViewModel)
            }
        }
        .task {
            // Initialize dependencies with authenticated user ID
            if dependencies == nil, let user = authViewModel.currentUser {
                dependencies = AppDependencies(userId: user.id)
            }
        }
        .onChange(of: authViewModel.currentUser) { _, newUser in
            // Re-create dependencies when user changes
            if let user = newUser {
                dependencies = AppDependencies(userId: user.id)
            } else {
                dependencies = nil
            }
        }
    }

    // MARK: - Header

    private var consoleHeader: LCARSConsoleHeader {
        guard isRedAlert else {
            return section.consoleHeader
        }

        return LCARSConsoleHeader(
            title: "RED ALERT",
            code: section.code,
            accent: .lcarAlert,
            secondary: .lcarRed,
            railColors: [.lcarAlert, .lcarRed, .lcarAlert, .lcarRed]
        )
    }

    // MARK: - Content

    @ViewBuilder private var sectionContent: some View {
        switch section {
        case .home:
            LCARSHomeViewIntegrated(onOpen: select)
        case .messages:
            if let user = authViewModel.currentUser {
                MessagesView(userId: user.id)
            }
        case .crew:
            LCARSUsersViewIntegrated()
        case .sensors:
            LCARSDashboardView()
        case .settings:
            LCARSSettingsViewIntegrated()
        }
    }

    @ViewBuilder
    private func routeDestination(for route: AppRoute) -> some View {
        switch route {
        case .profile(let userId):
            LCARSProfileViewIntegrated(userId: userId) {
                select(.messages)
            }
        }
    }

    // MARK: - Private Methods

    private func select(_ newSection: AppSection) {
        navigationPath = NavigationPath()
        section = newSection
    }
}
