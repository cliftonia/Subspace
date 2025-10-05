//
//  LCARSSettingsViewIntegrated.swift
//  Subspace
//
//  Created by Clifton Baggerman on 04/10/2025.
//

import SwiftUI
import os

/// LCARS-themed settings view with integrated design
struct LCARSSettingsViewIntegrated: View {

    // MARK: - Properties

    @Environment(AppDependencies.self) private var dependencies

    private let logger = Logger.app(category: "LCARSSettingsViewIntegrated")

    // MARK: - Body

    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color.lcarBlack
                    .ignoresSafeArea()

                VStack(spacing: 10) {
                    // Top frame
                    topFrame
                        .frame(height: max(geo.size.height / 3, 100))

                    // Bottom frame
                    bottomFrame
                        .frame(height: max(geo.size.height * 0.67 - 10, 100))
                }

                // Settings content
                settingsContent
                    .offset(x: 50, y: 60)
            }
        }
        .ignoresSafeArea()
        .onAppear {
            logger.logUserAction("Viewed LCARS Settings")
        }
    }

    // MARK: - Top Frame

    private var topFrame: some View {
        GeometryReader { geo in
            ZStack {
                VStack(spacing: 5) {
                    Color.lcarPlum
                    Color.lcarPink
                }
                .cornerRadius(70, corners: .bottomLeft)
                .overlay(alignment: .topTrailing) {
                    if geo.size.width > 100 && geo.size.height > 20 {
                        Color.lcarBlack
                            .cornerRadius(35, corners: .bottomLeft)
                            .frame(width: geo.size.width - 100, height: geo.size.height - 20)
                    }
                }
                .overlay(alignment: .topLeading) {
                    Color.lcarBlack
                        .frame(width: 100, height: 50)
                }
                .overlay(alignment: .bottomTrailing) {
                    ZStack {
                        Color.lcarBlack
                        HStack(spacing: 5) {
                            Color.lcarTan
                                .frame(width: 20)
                                .padding(.leading, 5)
                            Color.lcarViolet
                                .frame(width: 50)
                            Color.lcarOrange
                            Color.lcarLightOrange
                                .frame(width: 20)
                        }
                    }
                    .frame(width: 200, height: 20)
                }
                .overlay(alignment: .leading) {
                    VStack(alignment: .trailing, spacing: 15) {
                        Text("LCARS \(LCARSUtilities.randomDigits(5))")
                        Text("CFG-\(LCARSUtilities.randomDigits(6))")
                    }
                    .font(.custom("HelveticaNeue-CondensedBold", size: 17))
                    .foregroundStyle(Color.lcarBlack)
                    .scaleEffect(x: 0.7, anchor: .trailing)
                    .frame(width: 90)
                }
                .overlay(alignment: .topTrailing) {
                    Text("CONFIGURATION")
                        .font(.custom("HelveticaNeue-CondensedBold", size: 32))
                        .padding(.top, 45)
                        .foregroundStyle(Color.lcarOrange)
                        .scaleEffect(x: 0.7, anchor: .trailing)
                }
                .overlay(alignment: .trailing) {
                    settingsStatsGrid
                        .padding(.top, 40)
                }
            }
        }
    }

    /// Displays a decorative grid of random digits for LCARS aesthetic
    private var settingsStatsGrid: some View {
        Grid(alignment: .trailing) {
            ForEach(0..<7) { row in
                GridRow {
                    ForEach(0..<5) { _ in
                        Text(LCARSUtilities.randomDigits(Int.random(in: 1...6)))
                            .foregroundStyle((row == 2 || row == 3) ? Color.lcarWhite : Color.lcarPlum)
                    }
                }
            }
        }
        .font(.custom("HelveticaNeue-CondensedBold", size: 17))
    }

    // MARK: - Bottom Frame

    private var bottomFrame: some View {
        GeometryReader { geo in
            ZStack {
                VStack(alignment: .leading, spacing: 5) {
                    Color.lcarLightOrange
                        .frame(height: 100)
                        .overlay(alignment: .bottomLeading) {
                            LCARSUtilities.commonLabel(prefix: "APP")
                                .padding(.bottom, 5)
                        }
                    Color.lcarTan
                        .frame(height: 200)
                        .overlay(alignment: .bottomLeading) {
                            LCARSUtilities.commonLabel(prefix: "PRF")
                                .padding(.bottom, 5)
                        }
                    Color.lcarViolet
                        .frame(height: 50)
                        .overlay(alignment: .leading) {
                            LCARSUtilities.commonLabel(prefix: "SUP")
                        }
                    Color.lcarOrange
                        .overlay(alignment: .topLeading) {
                            LCARSUtilities.commonLabel(prefix: "SYS")
                                .padding(.top, 5)
                        }
                }
                .cornerRadius(70, corners: .topLeft)
                .overlay(alignment: .bottomTrailing) {
                    Color.lcarBlack
                        .cornerRadius(35, corners: .topLeft)
                        .frame(width: geo.size.width - 100, height: geo.size.height - 20)
                }
                .overlay(alignment: .bottomLeading) {
                    Color.lcarBlack
                        .frame(width: 100, height: 50)
                }
                .overlay(alignment: .topTrailing) {
                    ZStack {
                        Color.lcarBlack
                        HStack(alignment: .top, spacing: 5) {
                            Color.lcarPink
                                .frame(width: 20)
                                .padding(.leading, 5)
                            Color.lcarPlum
                                .frame(width: 50, height: 10)
                            Color.lcarTan
                            Color.lcarViolet
                                .frame(width: 20)
                        }
                    }
                    .frame(width: 200, height: 20)
                }
                .overlay(alignment: .bottomTrailing) {
                    Text("SYSTEM \(LCARSUtilities.randomDigits(3))")
                        .font(.custom("HelveticaNeue-CondensedBold", size: 35))
                        .padding(.bottom, 45)
                        .foregroundStyle(Color.lcarOrange)
                        .scaleEffect(x: 0.7, anchor: .trailing)
                }
            }
        }
    }

    // MARK: - Settings Content

    private var settingsContent: some View {
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
        .frame(width: 280)
    }

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
}

// MARK: - Preview

#Preview {
    NavigationStack {
        LCARSSettingsViewIntegrated()
            .environment(AppDependencies())
    }
}
