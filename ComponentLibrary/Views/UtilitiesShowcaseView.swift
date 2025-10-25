//
//  UtilitiesShowcaseView.swift
//  ComponentLibrary
//
//  Created by Clifton Baggerman on 04/10/2025.
//

import SwiftUI
import LCARSComponents

/// Showcase view for LCARS utilities
struct UtilitiesShowcaseView: View {
    var body: some View {
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
}
