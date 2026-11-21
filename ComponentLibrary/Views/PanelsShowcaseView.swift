//
//  PanelsShowcaseView.swift
//  ComponentLibrary
//
//  Created by Clifton Baggerman on 04/10/2025.
//

import LCARSComponents
import SwiftUI

/// Showcase view for LCARS panels
struct PanelsShowcaseView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            ShowcaseSection(title: "Heights") {
                VStack(spacing: 8) {
                    LCARSPanel(color: .lcarOrange, height: 50, label: "01-\(LCARSUtilities.stableDigits("a", count: 6))")
                    LCARSPanel(color: .lcarPink, height: 70, label: "02-\(LCARSUtilities.stableDigits("b", count: 6))")
                    LCARSPanel(color: .lcarViolet, height: 90, label: "03-\(LCARSUtilities.stableDigits("c", count: 6))")
                }
            }

            ShowcaseSection(title: "Corner Radius") {
                VStack(spacing: 8) {
                    LCARSPanel(color: .lcarTan, height: 60, cornerRadius: 10)
                    LCARSPanel(color: .lcarLightOrange, height: 60, cornerRadius: 30)
                }
            }
        }
    }
}
