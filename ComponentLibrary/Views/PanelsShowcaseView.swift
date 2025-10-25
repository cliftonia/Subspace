//
//  PanelsShowcaseView.swift
//  ComponentLibrary
//
//  Created by Clifton Baggerman on 04/10/2025.
//

import SwiftUI
import LCARSComponents

/// Showcase view for LCARS panels
struct PanelsShowcaseView: View {
    var body: some View {
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
}
