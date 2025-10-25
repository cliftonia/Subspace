//
//  AtomsShowcaseView.swift
//  ComponentLibrary
//
//  Created by Clifton Baggerman on 04/10/2025.
//

import SwiftUI
import LCARSComponents

/// Showcase view for LCARS atomic elements
struct AtomsShowcaseView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            ShowcaseSection(title: "Elbows") {
                HStack(spacing: 16) {
                    LCARSElbow(
                        position: .topLeading,
                        color: .lcarOrange,
                        size: 80,
                        label: "01"
                    )
                    LCARSElbow(
                        position: .topTrailing,
                        color: .lcarViolet,
                        size: 80,
                        label: "02"
                    )
                    LCARSElbow(
                        position: .bottomLeading,
                        color: .lcarPink,
                        size: 80,
                        label: "03"
                    )
                }
            }

            ShowcaseSection(title: "Bars & End Caps") {
                VStack(spacing: 12) {
                    HStack(spacing: 0) {
                        LCARSEndCap(
                            position: .leading,
                            color: .lcarTan,
                            size: CGSize(width: 50, height: 25)
                        )
                        LCARSBar(
                            orientation: .horizontal,
                            color: .lcarTan,
                            length: 150,
                            thickness: 25,
                            label: "SYSTEM"
                        )
                        LCARSEndCap(
                            position: .trailing,
                            color: .lcarTan,
                            size: CGSize(width: 50, height: 25)
                        )
                    }

                    HStack(spacing: 12) {
                        VStack(spacing: 0) {
                            LCARSEndCap(
                                position: .top,
                                color: .lcarLightOrange,
                                size: CGSize(width: 30, height: 50)
                            )
                            LCARSBar(
                                orientation: .vertical,
                                color: .lcarLightOrange,
                                length: 100,
                                thickness: 30
                            )
                            LCARSEndCap(
                                position: .bottom,
                                color: .lcarLightOrange,
                                size: CGSize(width: 30, height: 50)
                            )
                        }
                    }
                }
            }

            ShowcaseSection(title: "Brackets") {
                VStack(spacing: 12) {
                    LCARSBracket(
                        color: .lcarPlum,
                        label: "DATA GROUP"
                    ) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Item 1: Active")
                            Text("Item 2: Standby")
                            Text("Item 3: Offline")
                        }
                        .font(.custom("HelveticaNeue-CondensedBold", size: 12))
                        .foregroundStyle(Color.lcarWhite)
                    }

                    HStack(spacing: 40) {
                        LCARSCornerBracket(
                            position: .topLeading,
                            color: .lcarOrange,
                            length: 50
                        )
                        LCARSCornerBracket(
                            position: .bottomTrailing,
                            color: .lcarViolet,
                            length: 50
                        )
                    }
                }
            }
        }
    }
}
