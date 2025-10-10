//
//  OnboardingStorage.swift
//  Subspace
//
//  Created by Clifton Baggerman on 06/10/2025.
//

import Foundation

/// Service for persisting onboarding completion status
protocol OnboardingStorageProtocol: Sendable {
    func hasCompletedOnboarding() -> Bool
    func markOnboardingComplete()
    func resetOnboarding()
}

final class OnboardingStorage: OnboardingStorageProtocol, Sendable {
    // MARK: - Properties

    private let userDefaults: UserDefaults
    private let onboardingKey = "hasCompletedOnboarding"

    // MARK: - Initialization

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    // MARK: - Public Methods

    func hasCompletedOnboarding() -> Bool {
        userDefaults.bool(forKey: onboardingKey)
    }

    func markOnboardingComplete() {
        userDefaults.set(true, forKey: onboardingKey)
    }

    func resetOnboarding() {
        userDefaults.removeObject(forKey: onboardingKey)
    }
}
