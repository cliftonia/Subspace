//
//  AppRoute.swift
//  Subspace
//
//  Created by Clifton Baggerman on 03/10/2025.
//

import LCARSComponents
import SwiftUI

/// Destinations pushed within a section
enum AppRoute: Hashable {
    case profile(userId: String)
}

/// The primary areas of the console, selected from the arm of the frame
enum AppSection: Int, CaseIterable, Identifiable {
    case home
    case messages
    case crew
    case sensors
    case settings

    var id: Int { rawValue }

    /// Label on the navigation button
    var buttonTitle: String {
        switch self {
        case .home:
            return "OPS"
        case .messages:
            return "COMMS"
        case .crew:
            return "CREW"
        case .sensors:
            return "SENSORS"
        case .settings:
            return "CONFIG"
        }
    }

    /// Title displayed in the console header
    var headerTitle: String {
        switch self {
        case .home:
            return "OPERATIONS"
        case .messages:
            return "SUBSPACE COMMS"
        case .crew:
            return "PERSONNEL"
        case .sensors:
            return "LONG RANGE SENSORS"
        case .settings:
            return "CONFIGURATION"
        }
    }

    var color: Color {
        switch self {
        case .home:
            return .lcarOrange
        case .messages:
            return .lcarViolet
        case .crew:
            return .lcarTan
        case .sensors:
            return .lcarBlue
        case .settings:
            return .lcarPink
        }
    }

    /// Reference code shown in the arm of the frame
    var code: String {
        "\(rawValue + 1)-\(LCARSUtilities.stableDigits(headerTitle, count: 4))"
    }

    /// The header shown while this section is open
    var consoleHeader: LCARSConsoleHeader {
        LCARSConsoleHeader(
            title: headerTitle,
            code: code,
            accent: color,
            secondary: .lcarPink,
            railColors: [.lcarOrange, .lcarTan, .lcarViolet, .lcarGold]
        )
    }
}
