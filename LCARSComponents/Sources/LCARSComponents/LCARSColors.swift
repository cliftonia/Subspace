//
//  LCARSColors.swift
//  ComponentLibrary
//
//  Created by Clifton Baggerman on 04/10/2025.
//

import SwiftUI

/// LCARS color palette
public extension Color {
    static let lcarBlack = Color(red: 0, green: 0, blue: 0)
    static let lcarLightOrange = Color(red: 255/255, green: 153/255, blue: 102/255)
    static let lcarOrange = Color(red: 255/255, green: 153/255, blue: 0)
    static let lcarPink = Color(red: 204/255, green: 102/255, blue: 153/255)
    static let lcarPlum = Color(red: 153/255, green: 102/255, blue: 204/255)
    static let lcarTan = Color(red: 204/255, green: 153/255, blue: 102/255)
    static let lcarViolet = Color(red: 153/255, green: 102/255, blue: 255/255)
    static let lcarWhite = Color(red: 255/255, green: 255/255, blue: 255/255)

    /// Initialize Color from hex string
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 6: // RGB
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
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

/// Color showcase for documentation
public struct LCARSColorPalette: Identifiable, Sendable {
    public let id = UUID()
    public let name: String
    public let color: Color
    public let hex: String

    public static let all: [LCARSColorPalette] = [
        LCARSColorPalette(name: "LCARS Black", color: .lcarBlack, hex: "#000000"),
        LCARSColorPalette(name: "LCARS Orange", color: .lcarOrange, hex: "#FF9900"),
        LCARSColorPalette(name: "LCARS Light Orange", color: .lcarLightOrange, hex: "#FF9966"),
        LCARSColorPalette(name: "LCARS Pink", color: .lcarPink, hex: "#CC6699"),
        LCARSColorPalette(name: "LCARS Plum", color: .lcarPlum, hex: "#9966CC"),
        LCARSColorPalette(name: "LCARS Violet", color: .lcarViolet, hex: "#9966FF"),
        LCARSColorPalette(name: "LCARS Tan", color: .lcarTan, hex: "#CC9966"),
        LCARSColorPalette(name: "LCARS White", color: .lcarWhite, hex: "#FFFFFF")
    ]
}

// MARK: - Preview

#Preview("LCARS Colors") {
    ScrollView {
        LazyVStack(spacing: 16) {
            ForEach(LCARSColorPalette.all) { palette in
                HStack(spacing: 16) {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(palette.color)
                        .frame(width: 100, height: 100)
                        .overlay {
                            RoundedRectangle(cornerRadius: 20)
                                .strokeBorder(Color.white.opacity(0.2), lineWidth: 1)
                        }

                    VStack(alignment: .leading, spacing: 8) {
                        Text(palette.name)
                            .font(.custom("HelveticaNeue-CondensedBold", size: 20))
                            .foregroundStyle(Color.white)

                        Text(palette.hex)
                            .font(.custom("HelveticaNeue-CondensedBold", size: 16))
                            .foregroundStyle(Color.white.opacity(0.7))
                    }

                    Spacer()
                }
                .padding(16)
                .background(Color.lcarBlack.opacity(0.3))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
        .padding(20)
    }
    .background(Color.lcarBlack)
}
