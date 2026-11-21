//
//  UtilitiesShowcaseView.swift
//  ComponentLibrary
//
//  Created by Clifton Baggerman on 04/10/2025.
//

import LCARSComponents
import SwiftUI

/// Showcase view for LCARS utilities
struct UtilitiesShowcaseView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            ShowcaseSection(title: "Stable Digits") {
                VStack(spacing: 6) {
                    LCARSReadoutRow(label: "Seed OPS", value: LCARSUtilities.stableDigits("OPS", count: 6), color: .lcarOrange)
                    LCARSReadoutRow(label: "Seed CREW", value: LCARSUtilities.stableDigits("CREW", count: 6), color: .lcarViolet)
                }
            }

            ShowcaseSection(title: "Readouts") {
                VStack(spacing: 6) {
                    LCARSReadoutRow(label: "Warp", value: "9.975", color: .lcarTan)
                    LCARSReadoutRow(label: "Heading", value: "047 mark 2", color: .lcarBlue)
                }
            }
        }
    }
}
