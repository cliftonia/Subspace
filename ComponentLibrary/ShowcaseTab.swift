//
//  ShowcaseTab.swift
//  ComponentLibrary
//
//  Created by Clifton Baggerman on 04/10/2025.
//

import SwiftUI
import LCARSComponents

/// Tabs available in the component showcase
enum ShowcaseTab: Int, CaseIterable, Identifiable {
    case colors = 1
    case buttons = 2
    case panels = 3
    case atoms = 4
    case gauges = 5
    case sounds = 6
    case keyboard = 7
    case utilities = 8

    var id: Int { rawValue }

    var shortName: String {
        switch self {
        case .colors: return "COLORS"
        case .buttons: return "BUTTONS"
        case .panels: return "PANELS"
        case .atoms: return "ATOMS"
        case .gauges: return "GAUGES"
        case .sounds: return "SOUNDS"
        case .keyboard: return "KEYBOARD"
        case .utilities: return "UTILS"
        }
    }

    var title: String {
        switch self {
        case .colors: return "COLOR PALETTE"
        case .buttons: return "LCARS BUTTONS"
        case .panels: return "LCARS PANELS"
        case .atoms: return "ATOMIC ELEMENTS"
        case .gauges: return "GAUGES & INDICATORS"
        case .sounds: return "LCARS AUDIO"
        case .keyboard: return "LCARS KEYBOARD"
        case .utilities: return "UTILITIES"
        }
    }

    var description: String {
        switch self {
        case .colors:
            return "The LCARS Classic palette used throughout the interface."
        case .buttons:
            return "LCARS button and toggle styles, built on native SwiftUI controls."
        case .panels:
            return "Colored panels that form the backbone of the LCARS interface."
        case .atoms:
            return "Atomic design elements: elbows, rails, bars, end caps, and brackets."
        case .gauges:
            return "Visual indicators for displaying values and metrics."
        case .sounds:
            return "Authentic Star Trek LCARS sound effects."
        case .keyboard:
            return "Custom LCARS-themed keyboard with full character support."
        case .utilities:
            return "Utility functions for generating LCARS codes and identifiers."
        }
    }

    var consoleHeader: LCARSConsoleHeader {
        LCARSConsoleHeader(
            title: title,
            code: "\(rawValue)-\(LCARSUtilities.stableDigits(title, count: 4))",
            accent: color,
            secondary: .lcarPink,
            railColors: [.lcarOrange, .lcarTan, .lcarViolet, .lcarGold]
        )
    }

    var color: Color {
        switch self {
        case .colors: return .lcarViolet
        case .buttons: return .lcarOrange
        case .panels: return .lcarPink
        case .atoms: return .lcarLightOrange
        case .gauges: return .lcarPlum
        case .sounds: return .lcarGold
        case .keyboard: return .lcarTan
        case .utilities: return .lcarBlue
        }
    }
}
