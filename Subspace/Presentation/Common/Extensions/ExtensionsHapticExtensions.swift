//
//  HapticExtensions.swift
//  Subspace
//
//  Created by Clifton Baggerman on 03/10/2025.
//

import UIKit

// MARK: - Haptic Feedback

/// Utility for triggering haptic feedback
enum HapticFeedback {

    // MARK: - Impact Styles

    static func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }

    static func light() {
        impact(.light)
    }

    static func medium() {
        impact(.medium)
    }

    static func heavy() {
        impact(.heavy)
    }

    static func soft() {
        if #available(iOS 17.0, *) {
            impact(.soft)
        } else {
            impact(.light)
        }
    }

    static func rigid() {
        if #available(iOS 17.0, *) {
            impact(.rigid)
        } else {
            impact(.heavy)
        }
    }

    // MARK: - Notification Styles

    static func notification(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }

    static func success() {
        notification(.success)
    }

    static func warning() {
        notification(.warning)
    }

    static func error() {
        notification(.error)
    }

    // MARK: - Selection

    static func selection() {
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
    }
}
