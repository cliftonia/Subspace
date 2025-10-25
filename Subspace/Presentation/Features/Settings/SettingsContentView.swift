//
//  SettingsContentView.swift
//  Subspace
//
//  Created by Clifton Baggerman on 06/10/2025.
//

import LCARSComponents
import os
import SwiftUI

/// Settings content display view
struct SettingsContentView: View {
    // MARK: - Properties

    let dependencies: AppDependencies

    private let logger = Logger.app(category: "SettingsContentView")

    // MARK: - Body

    var body: some View {
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

            // Account
            sectionHeader("ACCOUNT")
            logoutButton()
        }
        .padding(.top, 24)
        .frame(width: 280)
    }

    // MARK: - Components

    /// Creates a section header with title and random digits
    /// - Parameter title: The section title text
    /// - Returns: A formatted section header view
    private func sectionHeader(_ title: String) -> some View {
        HStack {
            Text(title)
                .font(.custom("HelveticaNeue-CondensedBold", size: 12))
                .foregroundStyle(Color.lcarOrange)

            Spacer()

            Text(LCARSUtilities.randomDigits(3))
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
            // TODO: SUB-001 • Implement navigation for settings sections
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

    /// Creates a logout button with LCARS styling
    /// - Returns: A tappable logout button view
    private func logoutButton() -> some View {
        Button {
            Task {
                logger.logUserAction("Tapped LOGOUT")
                do {
                    try await dependencies.authService.logout()
                    logger.info("User logged out successfully")
                } catch {
                    logger.error("Logout failed: \(error.localizedDescription)")
                }
            }
        } label: {
            HStack(spacing: 8) {
                Image(systemName: "rectangle.portrait.and.arrow.right")
                    .font(.system(size: 12))
                    .foregroundStyle(Color.lcarRed)
                    .frame(width: 20)

                Text("LOGOUT")
                    .font(.custom("HelveticaNeue-CondensedBold", size: 12))
                    .foregroundStyle(Color.lcarWhite)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(8)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(Color.lcarRed, lineWidth: 1)
            )
        }
    }
}
