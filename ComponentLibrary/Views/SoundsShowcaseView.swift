//
//  SoundsShowcaseView.swift
//  ComponentLibrary
//
//  Created by Clifton Baggerman on 04/10/2025.
//

import SwiftUI
import LCARSComponents

/// Showcase view for LCARS sounds
struct SoundsShowcaseView: View {
    @State private var soundManager = LCARSSoundManager.shared

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Tricorder sounds
                ShowcaseSection(title: "TNG Tricorder Sounds") {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                        ForEach([
                            LCARSSoundManager.LCARSSound.tricorderOpen,
                            .tricorder1, .tricorder2, .tricorder3, .tricorder4,
                            .tricorder5, .tricorder6, .tricorder7, .tricorder8
                        ], id: \.self) { sound in
                            LCARSButton(
                                action: {
                                    LCARSSoundManager.shared.play(sound)
                                },
                                color: .lcarOrange,
                                width: 140,
                                height: 45,
                                cornerRadius: 15,
                                label: sound.rawValue.uppercased().replacingOccurrences(of: "TNG_", with: "")
                            )
                        }
                    }
                }

                // Interface sounds
                ShowcaseSection(title: "Interface Sounds") {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                        ForEach([
                            LCARSSoundManager.LCARSSound.viewscreenOn,
                            .viewscreenOff,
                            .entScreen1,
                            .entScreen2
                        ], id: \.self) { sound in
                            LCARSButton(
                                action: {
                                    LCARSSoundManager.shared.play(sound)
                                },
                                color: .lcarViolet,
                                width: 140,
                                height: 45,
                                cornerRadius: 15,
                                label: sound.displayName.uppercased()
                            )
                        }
                    }
                }

                // Classic sounds
                ShowcaseSection(title: "TOS Classic Sounds") {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                        ForEach([
                            LCARSSoundManager.LCARSSound.tosTricorderScan,
                            .tosTricorderAlert,
                            .tosViewscreen,
                            .tosViewscreenMagnification
                        ], id: \.self) { sound in
                            LCARSButton(
                                action: {
                                    LCARSSoundManager.shared.play(sound)
                                },
                                color: .lcarTan,
                                width: 140,
                                height: 45,
                                cornerRadius: 15,
                                label: sound.displayName.uppercased()
                            )
                        }
                    }
                }

                // Sound manager controls
                ShowcaseSection(title: "Sound Controls") {
                    VStack(alignment: .leading, spacing: 12) {
                        Toggle("Enable Sounds", isOn: $soundManager.isEnabled)
                            .tint(.lcarOrange)

                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text("Volume")
                                    .font(.system(size: 12, weight: .semibold))
                                Spacer()
                                Text("\(Int(soundManager.volume * 100))%")
                                    .font(.system(size: 12, design: .monospaced))
                                    .foregroundStyle(Color.lcarOrange)
                            }

                            Slider(value: $soundManager.volume, in: 0...1)
                                .tint(.lcarOrange)
                        }

                        Button {
                            LCARSSoundManager.shared.stopAll()
                        } label: {
                            Text("Stop All Sounds")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .padding(12)
                                .background(Color.lcarPlum)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        .sensoryFeedback(.warning, trigger: UUID())
                    }
                }
            }
        }
    }
}
