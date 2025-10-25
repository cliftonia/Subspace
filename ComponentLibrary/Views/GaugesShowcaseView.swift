//
//  GaugesShowcaseView.swift
//  ComponentLibrary
//
//  Created by Clifton Baggerman on 04/10/2025.
//

import SwiftUI
import LCARSComponents

/// Showcase view for LCARS gauges and indicators
struct GaugesShowcaseView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            ShowcaseSection(title: "Standard Gauges") {
                VStack(spacing: 16) {
                    LCARSGauge(
                        value: 75,
                        color: .lcarOrange,
                        label: "POWER SYSTEMS"
                    )

                    LCARSGauge(
                        value: 45,
                        color: .lcarViolet,
                        label: "SHIELD STRENGTH"
                    )

                    LCARSGauge(
                        value: 90,
                        color: .lcarPink,
                        label: "WARP CORE"
                    )
                }
            }

            ShowcaseSection(title: "Segmented Gauges") {
                VStack(spacing: 16) {
                    LCARSSegmentedGauge(
                        value: 60,
                        segments: 10,
                        color: .lcarTan,
                        label: "SENSOR ARRAY"
                    )

                    LCARSSegmentedGauge(
                        value: 85,
                        segments: 8,
                        color: .lcarLightOrange,
                        label: "IMPULSE ENGINES"
                    )
                }
            }
        }
    }
}
