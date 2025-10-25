//
//  LCARSColors.swift
//  ComponentLibrary
//
//  Created by Clifton Baggerman on 04/10/2025.
//

import SwiftUI

/// LCARS color palette
public extension Color {
    // Primary LCARS Colors
    static let lcarBlack = Color(red: 0, green: 0, blue: 0)
    static let lcarOrange = Color(red: 255/255, green: 147/255, blue: 0/255)        // #FF9300
    static let lcarPink = Color(red: 0xCC/255, green: 0x99/255, blue: 0xCC/255)    // #CC99CC
    static let lcarViolet = Color(red: 0x99/255, green: 0x99/255, blue: 0xFF/255)  // #9999FF
    static let lcarPlum = Color(red: 0xCC/255, green: 0x66/255, blue: 0x66/255)    // #CC6666
    static let lcarTan = Color(red: 0xFF/255, green: 0x99/255, blue: 0x66/255)     // #FF9966
    static let lcarLightOrange = Color(red: 0xFF/255, green: 0xBB/255, blue: 0x66/255) // #FFBB66
    static let lcarWhite = Color(red: 0xFF/255, green: 0xFF/255, blue: 0xFF/255)   // #FFFFFF

    // Additional LCARS Colors
    static let lcarBlue = Color(red: 0x99/255, green: 0xCC/255, blue: 0xFF/255)    // #99CCFF
    static let lcarGold = Color(red: 0xFF/255, green: 0xCC/255, blue: 0x66/255)    // #FFCC66
    static let lcarRed = Color(red: 0xFF/255, green: 0x66/255, blue: 0x66/255)     // #FF6666

    /// Initialize Color from hex string
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let alpha, red, green, blue: UInt64
        switch hex.count {
        case 6: // RGB
            (alpha, red, green, blue) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB
            (alpha, red, green, blue) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (alpha, red, green, blue) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(red) / 255,
            green: Double(green) / 255,
            blue: Double(blue) / 255,
            opacity: Double(alpha) / 255
        )
    }
}

// MARK: - LCARS Gradients

/// Predefined LCARS gradient styles
public struct LCARSGradients {
    public static let primary = LinearGradient(
        colors: [.lcarOrange, .lcarPink],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    public static let secondary = LinearGradient(
        colors: [.lcarViolet, .lcarPlum],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    public static let accent = LinearGradient(
        colors: [.lcarTan, .lcarLightOrange],
        startPoint: .leading,
        endPoint: .trailing
    )
}

/// Color showcase for documentation
public struct LCARSColorPalette: Identifiable, Sendable {
    public let id = UUID()
    public let name: String
    public let color: Color
    public let hex: String

    public static let all: [LCARSColorPalette] = [
        LCARSColorPalette(name: "LCARS Black", color: .lcarBlack, hex: "#000000"),
        LCARSColorPalette(name: "LCARS Orange", color: .lcarOrange, hex: "#FF9300"),
        LCARSColorPalette(name: "LCARS Light Orange", color: .lcarLightOrange, hex: "#FFBB66"),
        LCARSColorPalette(name: "LCARS Pink", color: .lcarPink, hex: "#CC99CC"),
        LCARSColorPalette(name: "LCARS Plum", color: .lcarPlum, hex: "#CC6666"),
        LCARSColorPalette(name: "LCARS Violet", color: .lcarViolet, hex: "#9999FF"),
        LCARSColorPalette(name: "LCARS Tan", color: .lcarTan, hex: "#FF9966"),
        LCARSColorPalette(name: "LCARS White", color: .lcarWhite, hex: "#FFFFFF"),
        LCARSColorPalette(name: "LCARS Blue", color: .lcarBlue, hex: "#99CCFF"),
        LCARSColorPalette(name: "LCARS Gold", color: .lcarGold, hex: "#FFCC66"),
        LCARSColorPalette(name: "LCARS Red", color: .lcarRed, hex: "#FF6666")
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
