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

    /// Triggers impact haptic feedback with specified style
    /// - Parameter style: The intensity of the haptic feedback
    static func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }

    /// Triggers light impact haptic feedback
    static func light() {
        impact(.light)
    }

    /// Triggers medium impact haptic feedback
    static func medium() {
        impact(.medium)
    }

    /// Triggers heavy impact haptic feedback
    static func heavy() {
        impact(.heavy)
    }

    /// Triggers soft impact haptic feedback (iOS 17+, falls back to light on older versions)
    static func soft() {
        if #available(iOS 17.0, *) {
            impact(.soft)
        } else {
            impact(.light)
        }
    }

    /// Triggers rigid impact haptic feedback (iOS 17+, falls back to heavy on older versions)
    static func rigid() {
        if #available(iOS 17.0, *) {
            impact(.rigid)
        } else {
            impact(.heavy)
        }
    }

    // MARK: - Notification Styles

    /// Triggers notification haptic feedback
    /// - Parameter type: The type of notification (success, warning, error)
    static func notification(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }

    /// Triggers success notification haptic feedback
    static func success() {
        notification(.success)
    }

    /// Triggers warning notification haptic feedback
    static func warning() {
        notification(.warning)
    }

    /// Triggers error notification haptic feedback
    static func error() {
        notification(.error)
    }

    // MARK: - Selection

    /// Triggers selection change haptic feedback
    static func selection() {
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
    }
}
