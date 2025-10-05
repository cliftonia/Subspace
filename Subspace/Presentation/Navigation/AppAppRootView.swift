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

    @State private var navigationPath = NavigationPath()
    @State private var dependencies = AppDependencies()

    // MARK: - Body

    var body: some View {
        NavigationStack(path: $navigationPath) {
            LCARSHomeViewIntegrated()
                .navigationDestination(for: AppRoute.self) { route in
                    routeDestination(for: route)
                }
        }
        .environment(dependencies)
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
            LCARSMessagesViewIntegratedNew()
        case .dashboard:
            LCARSDashboardView()
        }
    }
}