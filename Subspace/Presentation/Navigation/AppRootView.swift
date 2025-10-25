//
//  AppRootView.swift
//  Subspace
//
//  Created by Clifton Baggerman on 03/10/2025.
//

import SwiftUI

/// Root view that handles top-level navigation and app-wide state
struct AppRootView: View {
    // MARK: - Properties

    @Environment(AuthViewModel.self) private var authViewModel
    @State private var navigationPath = NavigationPath()
    @State private var dependencies: AppDependencies?

    // MARK: - Body

    var body: some View {
        Group {
            if let dependencies = dependencies {
                NavigationStack(path: $navigationPath) {
                    LCARSHomeViewIntegrated()
                        .navigationDestination(for: AppRoute.self) { route in
                            routeDestination(for: route)
                        }
                }
                .environment(dependencies)
                .environment(authViewModel)
            } else {
                // Show loading while initializing dependencies
                Color.lcarBlack
                    .ignoresSafeArea()
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

    // MARK: - Private Methods

    @ViewBuilder
    private func routeDestination(for route: AppRoute) -> some View {
        switch route {
        case .settings:
            LCARSSettingsViewIntegrated()
        case .profile(let userId):
            LCARSProfileViewIntegrated(userId: userId)
        case .users:
            LCARSUsersViewIntegrated()
        case .messages:
            if let user = authViewModel.currentUser {
                MessagesView(userId: user.id)
            } else {
                EmptyView()
            }
        case .dashboard:
            LCARSDashboardView()
        }
    }
}
