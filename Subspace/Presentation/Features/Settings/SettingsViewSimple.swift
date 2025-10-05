//
//  LCARSSettingsViewSimple.swift
//  Subspace
//
//  Created by Clifton Baggerman on 05/10/2025.
//

import SwiftUI
import os

/// LCARS-themed settings view using LCARSContentInFrame (simple layout)
struct LCARSSettingsViewSimple: View {

    // MARK: - Properties

    @Environment(AppDependencies.self) private var dependencies

    private let logger = Logger.app(category: "LCARSSettingsViewSimple")

    // MARK: - Body

    var body: some View {
        LCARSContentInFrame(
            topColors: [.lcarPlum, .lcarPink],
            bottomColors: [.lcarLightOrange, .lcarTan, .lcarViolet, .lcarOrange],
            topTitle: "CONFIGURATION",
            bottomTitle: "SYSTEM \(randomDigits(3))",
            topCode: "CFG",
            bottomCode: "SYS",
            bottomLabels: [
                ("APP", "Application"),
                ("PRF", "Preferences"),
                ("SUP", "Support"),
                ("SYS", "System")
            ]
        ) {
            ScrollView {
                VStack(spacing: 16) {
                    // App Info
                    sectionHeader("APP INFO")
                    settingRow(
                        label: "VERSION",
                        value: dependencies.settingsService.getAppVersion(),
                        color: Color.lcarOrange
                    )

                    // Preferences
                    sectionHeader("PREFERENCES")
                    navigationRow(label: "NOTIFICATIONS", icon: "bell.fill", color: Color.lcarViolet)
                    navigationRow(label: "PRIVACY", icon: "lock.fill", color: Color.lcarTan)
                    navigationRow(label: "APPEARANCE", icon: "paintbrush.fill", color: Color.lcarPink)

                    // Support
                    sectionHeader("SUPPORT")
                    actionRow(label: "CONTACT", icon: "questionmark.circle.fill", color: Color.lcarPlum)
                    actionRow(label: "POLICY", icon: "doc.text.fill", color: Color.lcarLightOrange)
                }
            }
        }
        .onAppear {
            logger.logUserAction("Viewed LCARS Settings")
        }
    }

    // MARK: - Section Components

    /// Creates a section header with title and random digits
    /// - Parameter title: The section title text
    /// - Returns: A formatted section header view
    private func sectionHeader(_ title: String) -> some View {
        HStack {
            Text(title)
                .font(.custom("HelveticaNeue-CondensedBold", size: 12))
                .foregroundStyle(Color.lcarOrange)

            Spacer()

            Text(randomDigits(3))
                .font(.custom("HelveticaNeue-CondensedBold", size: 10))
                .foregroundStyle(Color.lcarOrange.opacity(0.5))
        }
        .padding(.top, 8)
    }

    /// Creates a read-only setting row displaying a label and value
    /// - Parameters:
    ///   - label: The setting label
    ///   - value: The setting value
    ///   - color: The accent color for the label
    /// - Returns: A formatted setting row view
    private func settingRow(label: String, value: String, color: Color) -> some View {
        HStack(spacing: 8) {
            Text(label)
                .font(.custom("HelveticaNeue-CondensedBold", size: 10))
                .foregroundStyle(color)
                .frame(width: 70, alignment: .leading)

            Text(value)
                .font(.custom("HelveticaNeue", size: 12))
                .foregroundStyle(Color.lcarWhite)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder(color.opacity(0.5), lineWidth: 1)
        )
    }

    /// Creates a tappable navigation row with icon and chevron
    /// - Parameters:
    ///   - label: The row label
    ///   - icon: SF Symbol icon name
    ///   - color: The accent color for the icon and border
    /// - Returns: A tappable navigation row view
    private func navigationRow(label: String, icon: String, color: Color) -> some View {
        Button {
            HapticFeedback.light()
            // TODO: Navigate
        } label: {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 12))
                    .foregroundStyle(color)
                    .frame(width: 20)

                Text(label)
                    .font(.custom("HelveticaNeue-CondensedBold", size: 12))
                    .foregroundStyle(Color.lcarWhite)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Image(systemName: "chevron.right")
                    .font(.system(size: 10))
                    .foregroundStyle(Color.lcarTan)
            }
            .padding(8)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(color, lineWidth: 1)
            )
        }
    }

    /// Creates a tappable action row with icon for triggering actions
    /// - Parameters:
    ///   - label: The row label
    ///   - icon: SF Symbol icon name
    ///   - color: The accent color for the icon and border
    /// - Returns: A tappable action row view
    private func actionRow(label: String, icon: String, color: Color) -> some View {
        Button {
            logger.logUserAction("Tapped \(label)")
            HapticFeedback.light()
        } label: {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 12))
                    .foregroundStyle(color)
                    .frame(width: 20)

                Text(label)
                    .font(.custom("HelveticaNeue-CondensedBold", size: 12))
                    .foregroundStyle(Color.lcarWhite)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(8)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(color, lineWidth: 1)
            )
        }
    }

    /// Generates a string of random digits for LCARS aesthetic
    /// - Parameter count: Number of random digits to generate
    /// - Returns: String of random digits
    private func randomDigits(_ count: Int) -> String {
        (1...count).map { _ in "\(Int.random(in: 0...9))" }.joined()
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        LCARSSettingsViewSimple()
            .environment(AppDependencies())
    }
}
