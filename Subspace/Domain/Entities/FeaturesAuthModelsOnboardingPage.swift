//
//  OnboardingPage.swift
//  Subspace
//
//  Created by Clifton Baggerman on 04/10/2025.
//

import Foundation

/// Represents a single onboarding page
nonisolated struct OnboardingPage: Identifiable, Sendable {
    let id: UUID
    let title: String
    let description: String
    let systemImage: String
    let primaryColor: String
    let secondaryColor: String

    init(
        id: UUID = UUID(),
        title: String,
        description: String,
        systemImage: String,
        primaryColor: String,
        secondaryColor: String
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.systemImage = systemImage
        self.primaryColor = primaryColor
        self.secondaryColor = secondaryColor
    }
}

// MARK: - Sample Pages

extension OnboardingPage {
    static let samplePages: [OnboardingPage] = [
        OnboardingPage(
            title: "Connect with Users",
            description: "Browse and search through users to start building your gaming community",
            systemImage: "person.3.fill",
            primaryColor: "blue",
            secondaryColor: "cyan"
        ),
        OnboardingPage(
            title: "Real-time Messaging",
            description: "Send and receive messages instantly with WebSocket-powered real-time updates",
            systemImage: "message.fill",
            primaryColor: "purple",
            secondaryColor: "pink"
        ),
        OnboardingPage(
            title: "Stay Updated",
            description: "Get instant notifications for new messages and never miss important updates",
            systemImage: "bell.badge.fill",
            primaryColor: "orange",
            secondaryColor: "yellow"
        ),
        OnboardingPage(
            title: "Your Gaming Universe",
            description: "Everything you need to connect, communicate, and game together in one place",
            systemImage: "gamecontroller.fill",
            primaryColor: "green",
            secondaryColor: "mint"
        )
    ]
}
