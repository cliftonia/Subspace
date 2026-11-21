//
//  ButtonsShowcaseView.swift
//  ComponentLibrary
//
//  Created by Clifton Baggerman on 04/10/2025.
//

import LCARSComponents
import SwiftUI

/// Showcase view for LCARS buttons
struct ButtonsShowcaseView: View {
    @State private var isToggleOn = true

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            ShowcaseSection(title: "Pills") {
                VStack(spacing: 8) {
                    Button("Engage") {}
                        .buttonStyle(.lcars(.lcarOrange))
                    Button("Hail") {}
                        .buttonStyle(.lcars(.lcarViolet))
                    Button("Disabled") {}
                        .buttonStyle(.lcars(.lcarTan))
                        .disabled(true)
                }
            }

            ShowcaseSection(title: "Segments") {
                HStack(spacing: LCARSMetrics.gutter) {
                    Button("Port") {}
                        .buttonStyle(.lcars(.lcarOrange, form: .segment))
                    Button("Ahead") {}
                        .buttonStyle(.lcars(.lcarPink, form: .segment, isSelected: true))
                    Button("Starboard") {}
                        .buttonStyle(.lcars(.lcarBlue, form: .segment))
                }
            }

            ShowcaseSection(title: "Toggles") {
                Toggle("Shields", isOn: $isToggleOn)
                    .toggleStyle(.lcars(.lcarViolet))
            }
        }
    }
}
