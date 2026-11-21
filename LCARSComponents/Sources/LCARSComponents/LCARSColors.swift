//
//  LCARSColors.swift
//  LCARSComponents
//
//  Created by Clifton Baggerman on 04/10/2025.
//

import SwiftUI

/// LCARS palette, using the Classic theme values published at thelcars.com/colors.php
public extension Color {
    static let lcarBlack = Color(hex: "000000")
    static let lcarWhite = Color(hex: "F5F5F7")

    static let lcarOrange = Color(hex: "EB943A")        // orange
    static let lcarLightOrange = Color(hex: "EDB378")   // barley
    static let lcarGold = Color(hex: "EA9C72")          // butterscotch
    static let lcarTan = Color(hex: "FCC19F")           // almond-creme
    static let lcarPink = Color(hex: "C082A9")          // true-mauve
    static let lcarViolet = Color(hex: "BAA4E5")        // african-violet
    static let lcarBlue = Color(hex: "8899FF")          // bluey
    static let lcarPlum = Color(hex: "C47D69")          // subdued-sienna
    static let lcarRed = Color(hex: "CF4F4F")           // red
    static let lcarAlert = Color(hex: "FF2200")         // mars

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
