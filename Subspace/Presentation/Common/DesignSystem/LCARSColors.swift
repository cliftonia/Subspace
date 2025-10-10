//
//  LCARSColors.swift
//  Subspace
//
//  Created by Clifton Baggerman on 04/10/2025.
//

import SwiftUI

// MARK: - LCARS Color System

/// Star Trek LCARS (Library Computer Access/Retrieval System) color palette
extension Color {
    // Primary LCARS Colors
    static let lcarOrange = Color(red: 255 / 255, green: 147 / 255, blue: 0 / 255)        // #FF9300
    static let lcarPink = Color(red: 0xCC / 255, green: 0x99 / 255, blue: 0xCC / 255)    // #CC99CC
    static let lcarViolet = Color(red: 0x99 / 255, green: 0x99 / 255, blue: 0xFF / 255)  // #9999FF
    static let lcarPlum = Color(red: 0xCC / 255, green: 0x66 / 255, blue: 0x66 / 255)    // #CC6666
    static let lcarTan = Color(red: 0xFF / 255, green: 0x99 / 255, blue: 0x66 / 255)     // #FF9966
    static let lcarLightOrange = Color(red: 0xFF / 255, green: 0xBB / 255, blue: 0x66 / 255) // #FFBB66
    static let lcarWhite = Color(red: 0xFF / 255, green: 0xFF / 255, blue: 0xFF / 255)   // #FFFFFF

    // Additional LCARS Colors
    static let lcarBlue = Color(red: 0x99 / 255, green: 0xCC / 255, blue: 0xFF / 255)    // #99CCFF
    static let lcarGold = Color(red: 0xFF / 255, green: 0xCC / 255, blue: 0x66 / 255)    // #FFCC66
    static let lcarRed = Color(red: 0xFF / 255, green: 0x66 / 255, blue: 0x66 / 255)     // #FF6666

    // Background
    static let lcarBlack = Color.black
}

// MARK: - LCARS Gradients

struct LCARSGradients {
    static let primary = LinearGradient(
        colors: [.lcarOrange, .lcarPink],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let secondary = LinearGradient(
        colors: [.lcarViolet, .lcarPlum],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let accent = LinearGradient(
        colors: [.lcarTan, .lcarLightOrange],
        startPoint: .leading,
        endPoint: .trailing
    )
}
