//
//  SoundsShowcaseView.swift
//  ComponentLibrary
//
//  Created by Clifton Baggerman on 04/10/2025.
//

import LCARSComponents
import SwiftUI

/// Showcase view for LCARS sounds
struct SoundsShowcaseView: View {
    private typealias Sound = LCARSSoundManager.LCARSSound

    @State private var soundManager = LCARSSoundManager.shared

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            soundSection("TNG Tricorder", sounds: [.tricorderOpen, .tricorder1, .tricorder2, .tricorder3], color: .lcarOrange)
            soundSection("Interface", sounds: [.viewscreenOn, .viewscreenOff, .entScreen1, .entScreen2], color: .lcarViolet)
            soundSection("TOS Classic", sounds: [.tosTricorderScan, .tosTricorderAlert], color: .lcarTan)

            ShowcaseSection(title: "Controls") {
                VStack(spacing: 12) {
                    Toggle("Enable Sounds", isOn: $soundManager.isEnabled)
                        .toggleStyle(.lcars(.lcarOrange))

                    Slider(value: $soundManager.volume, in: 0...1)
                        .tint(.lcarOrange)
                        .accessibilityLabel("Volume")

                    Button("Stop All Sounds") {
                        soundManager.stopAll()
                    }
                    .buttonStyle(.lcars(.lcarRed))
                }
            }
        }
    }

    private func soundSection(_ title: String, sounds: [Sound], color: Color) -> some View {
        ShowcaseSection(title: title) {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: LCARSMetrics.gutter) {
                ForEach(sounds, id: \.self) { sound in
                    Button(sound.displayName) {
                        soundManager.play(sound)
                    }
                    .buttonStyle(.lcars(color, form: .segment))
                }
            }
        }
    }
}
