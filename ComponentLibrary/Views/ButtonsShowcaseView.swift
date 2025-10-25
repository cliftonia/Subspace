//
//  ButtonsShowcaseView.swift
//  ComponentLibrary
//
//  Created by Clifton Baggerman on 04/10/2025.
//

import SwiftUI
import LCARSComponents

/// Showcase view for LCARS buttons
struct ButtonsShowcaseView: View {
    var body: some View {
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
}
