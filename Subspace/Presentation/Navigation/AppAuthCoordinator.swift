//
//  AuthCoordinator.swift
//  Subspace
//
//  Created by Clifton Baggerman on 04/10/2025.
//

import SwiftUI

/// Coordinates authentication flow and app navigation
struct AuthCoordinator: View {

    // MARK: - Properties

    @State private var authViewModel: AuthViewModel
    @State private var showSplash = true
    @State private var hasCompletedOnboarding = false

    // MARK: - Initialization

    init() {
        // Use MockAuthService for development/demo
        let authService = MockAuthService()
        self._authViewModel = State(initialValue: AuthViewModel(authService: authService))
    }

    // MARK: - Body

    var body: some View {
        ZStack {
            // Main content based on auth state
            Group {
                switch authViewModel.authState {
                case .loading:
                    LCARSSplashView()

                case .authenticated:
                    AppRootView()

                case .unauthenticated, .error:
                    if showSplash {
                        LCARSSplashView()
                    } else if !hasCompletedOnboarding {
                        LCARSOnboardingView(onComplete: {
                            hasCompletedOnboarding = true
                        })
                        .transition(.opacity)
                    } else {
                        LCARSLoginView()
                            .transition(.opacity)
                    }
                }
            }
            .animation(.easeInOut(duration: 0.3), value: authViewModel.authState)
            .animation(.easeInOut(duration: 0.3), value: showSplash)
            .animation(.easeInOut(duration: 0.3), value: hasCompletedOnboarding)
        }
        .task {
            // Show splash for 2 seconds
            try? await Task.sleep(for: .seconds(2))
            showSplash = false

            // Check authentication status
            await authViewModel.checkAuthStatus()
        }
        .environment(authViewModel)
    }
}

#Preview {
    AuthCoordinator()
}
