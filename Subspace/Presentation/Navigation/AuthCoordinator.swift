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
    @State private var hasCompletedOnboarding: Bool

    private let onboardingStorage: OnboardingStorageProtocol

    // MARK: - Initialization

    /// Initializes the auth coordinator with real backend authentication
    init(onboardingStorage: OnboardingStorageProtocol = OnboardingStorage()) {
        // Use real AuthService to connect to backend
        // Set to MockAuthService() for offline development/testing
        let authService = AuthService()
        self._authViewModel = State(initialValue: AuthViewModel(authService: authService))
        self.onboardingStorage = onboardingStorage
        self._hasCompletedOnboarding = State(initialValue: onboardingStorage.hasCompletedOnboarding())
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
                    // Show onboarding for new users who haven't seen it yet
                    if !hasCompletedOnboarding {
                        LCARSOnboardingView(onComplete: {
                            hasCompletedOnboarding = true
                            onboardingStorage.markOnboardingComplete()
                        })
                        .transition(.opacity)
                    } else {
                        AppRootView()
                    }

                case .unauthenticated, .error:
                    if showSplash {
                        LCARSSplashView()
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
