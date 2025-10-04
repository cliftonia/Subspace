//
//  ComponentShowcaseView.swift
//  ComponentLibrary
//
//  Created by Clifton Baggerman on 04/10/2025.
//

import SwiftUI

/// Main showcase view displaying all LCARS components
struct ComponentShowcaseView: View {

    // MARK: - State

    @State private var selectedTab: ShowcaseTab = .buttons

    // MARK: - Body

    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color.lcarBlack
                    .ignoresSafeArea()

                VStack(spacing: 10) {
                    // Top frame
                    topFrame
                        .frame(height: geo.size.height / 5)

                    // Content area
                    contentArea
                        .frame(height: geo.size.height * (4/5) - 10)
                }
            }
        }
        .ignoresSafeArea()
    }

    // MARK: - Top Frame

    private var topFrame: some View {
        GeometryReader { geo in
            ZStack {
                VStack(spacing: 5) {
                    Color.lcarOrange
                    Color.lcarPink
                    Color.lcarViolet
                }
                .clipShape(RoundedRectangle(cornerRadius: 70))
                .overlay(alignment: .topTrailing) {
                    Color.lcarBlack
                        .clipShape(RoundedRectangle(cornerRadius: 35))
                        .frame(width: geo.size.width - 100, height: geo.size.height - 20)
                }
                .overlay(alignment: .topLeading) {
                    Color.lcarBlack
                        .frame(width: 100, height: 50)
                }
                .overlay(alignment: .topTrailing) {
                    Text("LCARS COMPONENT LIBRARY")
                        .font(.custom("HelveticaNeue-CondensedBold", size: 32))
                        .padding(.top, 40)
                        .foregroundStyle(Color.lcarOrange)
                        .scaleEffect(x: 0.7, anchor: .trailing)
                }
                .overlay(alignment: .leading) {
                    VStack(alignment: .trailing, spacing: 10) {
                        Text("LCARS \(LCARSUtilities.randomDigits(5))")
                        Text("VER-\(LCARSUtilities.randomDigits(3))")
                    }
                    .font(.custom("HelveticaNeue-CondensedBold", size: 17))
                    .foregroundStyle(Color.lcarBlack)
                    .scaleEffect(x: 0.7, anchor: .trailing)
                    .frame(width: 90)
                }
            }
        }
    }

    // MARK: - Content Area

    private var contentArea: some View {
        GeometryReader { geo in
            ZStack {
                // Left sidebar with navigation
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(ShowcaseTab.allCases) { tab in
                        Button {
                            withAnimation(.spring(response: 0.3)) {
                                selectedTab = tab
                            }
                        } label: {
                            LCARSPanel(
                                color: selectedTab == tab ? .lcarOrange : tab.color,
                                height: 70,
                                cornerRadius: 30,
                                label: LCARSUtilities.systemCode(section: String(format: "%02d", tab.rawValue))
                            )
                        }
                    }
                    Spacer()
                }
                .frame(width: 100)
                .padding(.leading, 8)
                .clipShape(RoundedRectangle(cornerRadius: 70))

                // Main content
                contentForSelectedTab
                    .frame(width: geo.size.width - 120)
                    .offset(x: 50)
            }
        }
    }

    // MARK: - Tab Content

    @ViewBuilder
    private var contentForSelectedTab: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Title
                Text(selectedTab.title)
                    .font(.custom("HelveticaNeue-CondensedBold", size: 36))
                    .foregroundStyle(Color.lcarOrange)

                // Description
                Text(selectedTab.description)
                    .font(.custom("HelveticaNeue", size: 16))
                    .foregroundStyle(Color.lcarWhite.opacity(0.8))

                Divider()
                    .background(Color.lcarOrange.opacity(0.3))
                    .padding(.vertical, 8)

                // Content
                switch selectedTab {
                case .colors:
                    colorsShowcase
                case .buttons:
                    buttonsShowcase
                case .panels:
                    panelsShowcase
                case .utilities:
                    utilitiesShowcase
                }
            }
            .padding(20)
        }
    }

    // MARK: - Colors Showcase

    private var colorsShowcase: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
            ForEach(LCARSColorPalette.all) { palette in
                VStack(spacing: 12) {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(palette.color)
                        .frame(height: 100)
                        .overlay {
                            RoundedRectangle(cornerRadius: 20)
                                .strokeBorder(Color.white.opacity(0.1), lineWidth: 1)
                        }

                    VStack(alignment: .leading, spacing: 4) {
                        Text(palette.name)
                            .font(.custom("HelveticaNeue-CondensedBold", size: 14))
                            .foregroundStyle(Color.lcarWhite)

                        Text(palette.hex)
                            .font(.custom("HelveticaNeue", size: 12))
                            .foregroundStyle(Color.lcarWhite.opacity(0.6))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
    }

    // MARK: - Buttons Showcase

    private var buttonsShowcase: some View {
        VStack(alignment: .leading, spacing: 24) {
            // Standard sizes
            ShowcaseSection(title: "Standard Buttons") {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    LCARSButton(
                        action: {},
                        color: .lcarOrange,
                        label: LCARSUtilities.randomDigits(7)
                    )

                    LCARSButton(
                        action: {},
                        color: .lcarViolet,
                        label: LCARSUtilities.randomDigits(7)
                    )

                    LCARSButton(
                        action: {},
                        color: .lcarTan,
                        label: LCARSUtilities.randomDigits(7)
                    )

                    LCARSButton(
                        action: {},
                        color: .lcarPink,
                        label: LCARSUtilities.randomDigits(7)
                    )
                }
            }

            // Large buttons
            ShowcaseSection(title: "Large Buttons") {
                VStack(spacing: 12) {
                    LCARSButton(
                        action: {},
                        color: .lcarPlum,
                        width: 250,
                        height: 60,
                        cornerRadius: 30,
                        label: LCARSUtilities.lcarCode()
                    )

                    LCARSButton(
                        action: {},
                        color: .lcarLightOrange,
                        width: 250,
                        height: 60,
                        cornerRadius: 30,
                        label: LCARSUtilities.lcarCode()
                    )
                }
            }

            // Without labels
            ShowcaseSection(title: "Unlabeled Buttons") {
                HStack(spacing: 12) {
                    LCARSButton(action: {}, color: .lcarOrange)
                    LCARSButton(action: {}, color: .lcarViolet)
                    LCARSButton(action: {}, color: .lcarTan)
                }
            }
        }
    }

    // MARK: - Panels Showcase

    private var panelsShowcase: some View {
        VStack(alignment: .leading, spacing: 24) {
            ShowcaseSection(title: "Panel Heights") {
                VStack(spacing: 8) {
                    LCARSPanel(
                        color: .lcarOrange,
                        height: 60,
                        label: LCARSUtilities.systemCode(section: "01")
                    )

                    LCARSPanel(
                        color: .lcarPink,
                        height: 80,
                        label: LCARSUtilities.systemCode(section: "02")
                    )

                    LCARSPanel(
                        color: .lcarViolet,
                        height: 100,
                        label: LCARSUtilities.systemCode(section: "03")
                    )

                    LCARSPanel(
                        color: .lcarPlum,
                        height: 120,
                        label: LCARSUtilities.systemCode(section: "04")
                    )
                }
            }

            ShowcaseSection(title: "Corner Radius Variants") {
                VStack(spacing: 8) {
                    LCARSPanel(color: .lcarTan, height: 80, cornerRadius: 10)
                    LCARSPanel(color: .lcarLightOrange, height: 80, cornerRadius: 25)
                    LCARSPanel(color: .lcarOrange, height: 80, cornerRadius: 40)
                    LCARSPanel(color: .lcarPink, height: 80, cornerRadius: 50)
                }
            }
        }
    }

    // MARK: - Utilities Showcase

    private var utilitiesShowcase: some View {
        VStack(alignment: .leading, spacing: 24) {
            ShowcaseSection(title: "Random Digits") {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(3..<8) { count in
                        Text("\(count) digits: \(LCARSUtilities.randomDigits(count))")
                            .font(.custom("HelveticaNeue-CondensedBold", size: 16))
                            .foregroundStyle(Color.lcarOrange)
                    }
                }
            }

            ShowcaseSection(title: "LCARS Codes") {
                VStack(alignment: .leading, spacing: 8) {
                    Text(LCARSUtilities.lcarCode())
                        .font(.custom("HelveticaNeue-CondensedBold", size: 16))
                        .foregroundStyle(Color.lcarOrange)

                    Text(LCARSUtilities.lcarCode(prefix: "ACCESS", digits: 3))
                        .font(.custom("HelveticaNeue-CondensedBold", size: 16))
                        .foregroundStyle(Color.lcarViolet)

                    Text(LCARSUtilities.lcarCode(prefix: "NODE", digits: 4))
                        .font(.custom("HelveticaNeue-CondensedBold", size: 16))
                        .foregroundStyle(Color.lcarTan)
                }
            }

            ShowcaseSection(title: "System Codes") {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(1..<6) { section in
                        Text(LCARSUtilities.systemCode(section: String(format: "%02d", section)))
                            .font(.custom("HelveticaNeue-CondensedBold", size: 16))
                            .foregroundStyle(Color.lcarPink)
                    }
                }
            }
        }
    }
}

// MARK: - Showcase Section

struct ShowcaseSection<Content: View>: View {
    let title: String
    let content: Content

    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.custom("HelveticaNeue-CondensedBold", size: 18))
                .foregroundStyle(Color.lcarWhite)

            content
        }
    }
}

// MARK: - Showcase Tab

enum ShowcaseTab: Int, CaseIterable, Identifiable {
    case colors = 1
    case buttons = 2
    case panels = 3
    case utilities = 4

    var id: Int { rawValue }

    var title: String {
        switch self {
        case .colors: return "COLOR PALETTE"
        case .buttons: return "LCARS BUTTONS"
        case .panels: return "LCARS PANELS"
        case .utilities: return "UTILITIES"
        }
    }

    var description: String {
        switch self {
        case .colors:
            return "The official LCARS color palette used throughout the interface. These colors are carefully chosen to match the Star Trek LCARS design system."
        case .buttons:
            return "Interactive LCARS-style buttons with customizable colors, sizes, and labels. Perfect for actions and navigation."
        case .panels:
            return "Colored panels that form the backbone of the LCARS interface. Configurable heights and corner radii."
        case .utilities:
            return "Utility functions for generating LCARS codes, random digits, and system identifiers."
        }
    }

    var color: Color {
        switch self {
        case .colors: return .lcarViolet
        case .buttons: return .lcarOrange
        case .panels: return .lcarPink
        case .utilities: return .lcarTan
        }
    }
}

// MARK: - Preview

#Preview {
    ComponentShowcaseView()
}
