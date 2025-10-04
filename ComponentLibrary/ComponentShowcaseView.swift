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
                        .frame(height: max(geo.size.height / 5, 100))

                    // Content area
                    contentArea
                        .frame(height: max(geo.size.height * 0.8 - 10, 100))
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
                    selectedTab.color
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
                    Text(selectedTab.title)
                        .font(.custom("HelveticaNeue-CondensedBold", size: 32))
                        .padding(.top, 50)
                        .padding(.trailing, 20)
                        .foregroundStyle(selectedTab.color)
                        .scaleEffect(x: 0.7, anchor: .trailing)
                }
                .overlay(alignment: .leading) {
                    VStack(alignment: .trailing, spacing: 10) {
                        Text("LCARS \(LCARSUtilities.randomDigits(5))")
                        Text(String(format: "%02d", selectedTab.rawValue) + "-\(LCARSUtilities.randomDigits(6))")
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
        HStack(spacing: 0) {
            // Left sidebar with navigation
            VStack(spacing: 8) {
                ForEach(ShowcaseTab.allCases) { tab in
                    Button {
                        withAnimation(.spring(response: 0.3)) {
                            selectedTab = tab
                        }
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 30)
                                .fill(selectedTab == tab ? Color.lcarOrange : tab.color)
                                .frame(height: 80)

                            VStack(spacing: 4) {
                                Text(tab.shortName)
                                    .font(.custom("HelveticaNeue-CondensedBold", size: 11))
                                    .foregroundStyle(Color.lcarBlack)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.7)
                                    .frame(maxWidth: .infinity, alignment: .trailing)

                                Text(LCARSUtilities.systemCode(section: String(format: "%02d", tab.rawValue)))
                                    .font(.custom("HelveticaNeue-CondensedBold", size: 10))
                                    .foregroundStyle(Color.lcarBlack)
                                    .scaleEffect(x: 0.8, anchor: .trailing)
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                            }
                            .padding(.horizontal, 8)
                            .padding(.trailing, 4)
                        }
                    }
                }
                Spacer()
            }
            .frame(width: 100)
            .padding(.leading, 8)

            // Main content
            contentForSelectedTab
                .padding(.leading, 20)
        }
    }

    // MARK: - Tab Content

    @ViewBuilder
    private var contentForSelectedTab: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Title
                Text(selectedTab.title)
                    .font(.custom("HelveticaNeue-CondensedBold", size: 28))
                    .foregroundStyle(Color.lcarOrange)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)

                // Description
                Text(selectedTab.description)
                    .font(.system(size: 14))
                    .foregroundStyle(Color.lcarWhite.opacity(0.8))
                    .lineLimit(3)
                    .multilineTextAlignment(.leading)

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
                case .atoms:
                    atomsShowcase
                case .gauges:
                    gaugesShowcase
                case .keyboard:
                    keyboardShowcase
                case .utilities:
                    utilitiesShowcase
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
        }
    }

    // MARK: - Colors Showcase

    private var colorsShowcase: some View {
        VStack(spacing: 12) {
            ForEach(LCARSColorPalette.all) { palette in
                HStack(spacing: 12) {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(palette.color)
                        .frame(width: 80, height: 60)
                        .overlay {
                            RoundedRectangle(cornerRadius: 15)
                                .strokeBorder(Color.white.opacity(0.1), lineWidth: 1)
                        }

                    VStack(alignment: .leading, spacing: 4) {
                        Text(palette.name)
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(Color.lcarWhite)

                        Text(palette.hex)
                            .font(.system(size: 12, design: .monospaced))
                            .foregroundStyle(Color.lcarWhite.opacity(0.6))
                    }

                    Spacer()
                }
                .padding(8)
                .background(Color.white.opacity(0.05))
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
        }
    }

    // MARK: - Buttons Showcase

    private var buttonsShowcase: some View {
        VStack(alignment: .leading, spacing: 20) {
            ShowcaseSection(title: "Standard") {
                VStack(spacing: 12) {
                    LCARSButton(
                        action: {},
                        color: .lcarOrange,
                        width: 180,
                        label: LCARSUtilities.randomDigits(7)
                    )

                    LCARSButton(
                        action: {},
                        color: .lcarViolet,
                        width: 180,
                        label: LCARSUtilities.randomDigits(7)
                    )

                    LCARSButton(
                        action: {},
                        color: .lcarTan,
                        width: 180,
                        label: LCARSUtilities.randomDigits(7)
                    )
                }
            }

            ShowcaseSection(title: "Colors") {
                HStack(spacing: 8) {
                    LCARSButton(action: {}, color: .lcarOrange, width: 60, height: 60)
                    LCARSButton(action: {}, color: .lcarPink, width: 60, height: 60)
                    LCARSButton(action: {}, color: .lcarViolet, width: 60, height: 60)
                    LCARSButton(action: {}, color: .lcarPlum, width: 60, height: 60)
                }
            }
        }
    }

    // MARK: - Panels Showcase

    private var panelsShowcase: some View {
        VStack(alignment: .leading, spacing: 20) {
            ShowcaseSection(title: "Heights") {
                VStack(spacing: 8) {
                    LCARSPanel(
                        color: .lcarOrange,
                        height: 50,
                        label: LCARSUtilities.systemCode(section: "01")
                    )

                    LCARSPanel(
                        color: .lcarPink,
                        height: 70,
                        label: LCARSUtilities.systemCode(section: "02")
                    )

                    LCARSPanel(
                        color: .lcarViolet,
                        height: 90,
                        label: LCARSUtilities.systemCode(section: "03")
                    )
                }
            }

            ShowcaseSection(title: "Corner Radius") {
                VStack(spacing: 8) {
                    LCARSPanel(color: .lcarTan, height: 60, cornerRadius: 10)
                    LCARSPanel(color: .lcarLightOrange, height: 60, cornerRadius: 30)
                    LCARSPanel(color: .lcarPlum, height: 60, cornerRadius: 50)
                }
            }
        }
    }

    // MARK: - Utilities Showcase

    private var utilitiesShowcase: some View {
        VStack(alignment: .leading, spacing: 20) {
            ShowcaseSection(title: "Random Digits") {
                VStack(alignment: .leading, spacing: 6) {
                    Text("3: \(LCARSUtilities.randomDigits(3))")
                        .font(.system(size: 14, design: .monospaced))
                        .foregroundStyle(Color.lcarOrange)

                    Text("5: \(LCARSUtilities.randomDigits(5))")
                        .font(.system(size: 14, design: .monospaced))
                        .foregroundStyle(Color.lcarOrange)

                    Text("7: \(LCARSUtilities.randomDigits(7))")
                        .font(.system(size: 14, design: .monospaced))
                        .foregroundStyle(Color.lcarOrange)
                }
            }

            ShowcaseSection(title: "LCARS Codes") {
                VStack(alignment: .leading, spacing: 6) {
                    Text(LCARSUtilities.lcarCode())
                        .font(.system(size: 14, design: .monospaced))
                        .foregroundStyle(Color.lcarViolet)

                    Text(LCARSUtilities.lcarCode(prefix: "ACCESS", digits: 3))
                        .font(.system(size: 14, design: .monospaced))
                        .foregroundStyle(Color.lcarTan)
                }
            }

            ShowcaseSection(title: "System Codes") {
                VStack(alignment: .leading, spacing: 6) {
                    Text(LCARSUtilities.systemCode(section: "01"))
                        .font(.system(size: 14, design: .monospaced))
                        .foregroundStyle(Color.lcarPink)

                    Text(LCARSUtilities.systemCode(section: "02"))
                        .font(.system(size: 14, design: .monospaced))
                        .foregroundStyle(Color.lcarPink)

                    Text(LCARSUtilities.systemCode(section: "03"))
                        .font(.system(size: 14, design: .monospaced))
                        .foregroundStyle(Color.lcarPink)
                }
            }
        }
    }

    // MARK: - Atoms Showcase

    private var atomsShowcase: some View {
        VStack(alignment: .leading, spacing: 20) {
            ShowcaseSection(title: "Elbows") {
                HStack(spacing: 16) {
                    LCARSElbow(
                        position: .topLeading,
                        color: .lcarOrange,
                        size: 80,
                        label: "01"
                    )
                    LCARSElbow(
                        position: .topTrailing,
                        color: .lcarViolet,
                        size: 80,
                        label: "02"
                    )
                    LCARSElbow(
                        position: .bottomLeading,
                        color: .lcarPink,
                        size: 80,
                        label: "03"
                    )
                }
            }

            ShowcaseSection(title: "Bars & End Caps") {
                VStack(spacing: 12) {
                    HStack(spacing: 0) {
                        LCARSEndCap(
                            position: .leading,
                            color: .lcarTan,
                            size: CGSize(width: 50, height: 25)
                        )
                        LCARSBar(
                            orientation: .horizontal,
                            color: .lcarTan,
                            length: 150,
                            thickness: 25,
                            label: "SYSTEM"
                        )
                        LCARSEndCap(
                            position: .trailing,
                            color: .lcarTan,
                            size: CGSize(width: 50, height: 25)
                        )
                    }

                    HStack(spacing: 12) {
                        VStack(spacing: 0) {
                            LCARSEndCap(
                                position: .top,
                                color: .lcarLightOrange,
                                size: CGSize(width: 30, height: 50)
                            )
                            LCARSBar(
                                orientation: .vertical,
                                color: .lcarLightOrange,
                                length: 100,
                                thickness: 30
                            )
                            LCARSEndCap(
                                position: .bottom,
                                color: .lcarLightOrange,
                                size: CGSize(width: 30, height: 50)
                            )
                        }
                    }
                }
            }

            ShowcaseSection(title: "Brackets") {
                VStack(spacing: 12) {
                    LCARSBracket(
                        color: .lcarPlum,
                        label: "DATA GROUP"
                    ) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Item 1: Active")
                            Text("Item 2: Standby")
                            Text("Item 3: Offline")
                        }
                        .font(.custom("HelveticaNeue-CondensedBold", size: 12))
                        .foregroundStyle(Color.lcarWhite)
                    }

                    HStack(spacing: 40) {
                        LCARSCornerBracket(
                            position: .topLeading,
                            color: .lcarOrange,
                            length: 50
                        )
                        LCARSCornerBracket(
                            position: .bottomTrailing,
                            color: .lcarViolet,
                            length: 50
                        )
                    }
                }
            }
        }
    }

    // MARK: - Gauges Showcase

    private var gaugesShowcase: some View {
        VStack(alignment: .leading, spacing: 20) {
            ShowcaseSection(title: "Standard Gauges") {
                VStack(spacing: 16) {
                    LCARSGauge(
                        value: 75,
                        color: .lcarOrange,
                        label: "POWER SYSTEMS"
                    )

                    LCARSGauge(
                        value: 45,
                        color: .lcarViolet,
                        label: "SHIELD STRENGTH"
                    )

                    LCARSGauge(
                        value: 90,
                        color: .lcarPink,
                        label: "WARP CORE"
                    )
                }
            }

            ShowcaseSection(title: "Segmented Gauges") {
                VStack(spacing: 16) {
                    LCARSSegmentedGauge(
                        value: 60,
                        segments: 10,
                        color: .lcarTan,
                        label: "SENSOR ARRAY"
                    )

                    LCARSSegmentedGauge(
                        value: 85,
                        segments: 8,
                        color: .lcarLightOrange,
                        label: "IMPULSE ENGINES"
                    )
                }
            }
        }
    }

    // MARK: - Keyboard Showcase

    private var keyboardShowcase: some View {
        @State var keyboardText = ""

        return VStack(alignment: .leading, spacing: 20) {
            ShowcaseSection(title: "Input Display") {
                VStack(alignment: .leading, spacing: 8) {
                    Text("OUTPUT")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundStyle(Color.lcarOrange)

                    Text(keyboardText.isEmpty ? "Type something..." : keyboardText)
                        .font(.system(size: 16))
                        .foregroundStyle(keyboardText.isEmpty ? Color.lcarWhite.opacity(0.3) : Color.lcarWhite)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(12)
                        .background(Color.white.opacity(0.05))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }

            ShowcaseSection(title: "Keyboard") {
                LCARSKeyboard(text: $keyboardText)
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
    case atoms = 4
    case gauges = 5
    case keyboard = 6
    case utilities = 7

    var id: Int { rawValue }

    var shortName: String {
        switch self {
        case .colors: return "COLORS"
        case .buttons: return "BUTTONS"
        case .panels: return "PANELS"
        case .atoms: return "ATOMS"
        case .gauges: return "GAUGES"
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
        case .keyboard: return "LCARS KEYBOARD"
        case .utilities: return "UTILITIES"
        }
    }

    var description: String {
        switch self {
        case .colors:
            return "The official LCARS color palette used throughout the interface."
        case .buttons:
            return "Interactive LCARS-style buttons with customizable colors and sizes."
        case .panels:
            return "Colored panels that form the backbone of the LCARS interface."
        case .atoms:
            return "Atomic design elements: elbows, bars, end caps, and brackets."
        case .gauges:
            return "Visual indicators for displaying values and metrics."
        case .keyboard:
            return "Custom LCARS-themed keyboard with full character support."
        case .utilities:
            return "Utility functions for generating LCARS codes and identifiers."
        }
    }

    var color: Color {
        switch self {
        case .colors: return .lcarViolet
        case .buttons: return .lcarOrange
        case .panels: return .lcarPink
        case .atoms: return .lcarLightOrange
        case .gauges: return .lcarPlum
        case .keyboard: return .lcarTan
        case .utilities: return Color(hex: "CC9966")
        }
    }
}

// MARK: - Color Extension

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 6: // RGB
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - Preview

#Preview {
    ComponentShowcaseView()
}
