//
//  ColorsShowcaseView.swift
//  ComponentLibrary
//
//  Created by Clifton Baggerman on 04/10/2025.
//

import LCARSComponents
import SwiftUI

/// Showcase view for LCARS color palette
struct ColorsShowcaseView: View {
    private struct Swatch: Identifiable {
        let name: String
        let hex: String

        var id: String { name }
    }

    private let swatches = [
        Swatch(name: "Orange", hex: "EB943A"),
        Swatch(name: "Barley", hex: "EDB378"),
        Swatch(name: "Butterscotch", hex: "EA9C72"),
        Swatch(name: "Almond Creme", hex: "FCC19F"),
        Swatch(name: "True Mauve", hex: "C082A9"),
        Swatch(name: "African Violet", hex: "BAA4E5"),
        Swatch(name: "Bluey", hex: "8899FF"),
        Swatch(name: "Subdued Sienna", hex: "C47D69"),
        Swatch(name: "Red", hex: "CF4F4F"),
        Swatch(name: "Mars", hex: "FF2200")
    ]

    var body: some View {
        VStack(spacing: LCARSMetrics.gutter) {
            ForEach(swatches) { swatch in
                HStack(spacing: 12) {
                    Color(hex: swatch.hex)
                        .frame(width: 96, height: 44)

                    Text(swatch.name.uppercased())
                        .font(.lcars(20))
                        .foregroundStyle(Color(hex: swatch.hex))
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Text("#\(swatch.hex)")
                        .font(.lcars(17))
                        .foregroundStyle(Color.lcarWhite.opacity(0.7))
                }
                .accessibilityElement(children: .combine)
            }
        }
    }
}
