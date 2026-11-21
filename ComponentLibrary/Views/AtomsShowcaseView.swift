//
//  AtomsShowcaseView.swift
//  ComponentLibrary
//
//  Created by Clifton Baggerman on 04/10/2025.
//

import LCARSComponents
import SwiftUI

/// Showcase view for LCARS atomic elements
struct AtomsShowcaseView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            ShowcaseSection(title: "Elbows") {
                Grid(horizontalSpacing: 8, verticalSpacing: 8) {
                    GridRow {
                        elbow(.topLeading, color: .lcarOrange)
                        elbow(.topTrailing, color: .lcarViolet)
                    }
                    GridRow {
                        elbow(.bottomLeading, color: .lcarPink)
                        elbow(.bottomTrailing, color: .lcarTan)
                    }
                }
            }

            ShowcaseSection(title: "Rails") {
                LCARSRail(colors: [.lcarOrange, .lcarTan, .lcarViolet, .lcarGold])
            }

            ShowcaseSection(title: "Bars and End Caps") {
                HStack(spacing: 0) {
                    LCARSEndCap(position: .leading, color: .lcarTan, size: CGSize(width: 40, height: 25))
                    LCARSBar(orientation: .horizontal, color: .lcarTan, length: 150, thickness: 25, label: "SYSTEM")
                    LCARSEndCap(position: .trailing, color: .lcarTan, size: CGSize(width: 40, height: 25))
                }
            }

            ShowcaseSection(title: "Brackets") {
                LCARSBracket(color: .lcarPlum, label: "DATA GROUP") {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("ITEM 1: ACTIVE")
                        Text("ITEM 2: STANDBY")
                        Text("ITEM 3: OFFLINE")
                    }
                    .font(.lcars(18))
                    .foregroundStyle(Color.lcarWhite)
                }
            }

            ShowcaseSection(title: "Data Cascade") {
                LCARSDataCascade(seed: "showcase")
            }
        }
    }

    private func elbow(_ corner: LCARSElbow.Corner, color: Color) -> some View {
        LCARSElbow(corner: corner, armWidth: 44, railHeight: 12, outerRadius: 32, innerRadius: 14)
            .fill(color)
            .frame(height: 70)
    }
}
