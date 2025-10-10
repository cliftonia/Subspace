//
//  AppRoute.swift
//  Subspace
//
//  Created by Clifton Baggerman on 03/10/2025.
//

import Foundation

/// Type-safe routing system for app navigation
enum AppRoute: Hashable, CaseIterable {
    case settings
    case profile(userId: String)
    case users
    case messages
    case dashboard

    // MARK: - CaseIterable Conformance

    static var allCases: [AppRoute] {
        [.settings, .profile(userId: "example"), .users, .messages, .dashboard]
    }

    // MARK: - Display Properties

    /// Human-readable title for the route
    var title: String {
        switch self {
        case .settings:
            return "Settings"
        case .profile:
            return "Profile"
        case .users:
            return "Users"
        case .messages:
            return "Messages"
        case .dashboard:
            return "Dashboard"
        }
    }

    /// SF Symbol name for the route icon
    var systemImage: String {
        switch self {
        case .settings:
            return "gear"
        case .profile:
            return "person.circle"
        case .users:
            return "person.2"
        case .messages:
            return "message"
        case .dashboard:
            return "chart.line.uptrend.xyaxis"
        }
    }
}
