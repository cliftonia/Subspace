//
//  LCARSSoundManager.swift
//  ComponentLibrary
//
//  Created by Clifton Baggerman on 04/10/2025.
//

import AVFoundation
import SwiftUI

/// LCARS sound effects manager
@Observable
final class LCARSSoundManager: @unchecked Sendable {

    // MARK: - Singleton

    static let shared = LCARSSoundManager()

    // MARK: - Properties

    private var audioPlayers: [String: AVAudioPlayer] = [:]
    private let lock = NSLock()

    var isEnabled: Bool = true
    var volume: Float = 0.5

    // MARK: - Sound Types

    enum LCARSSound: String, CaseIterable, Hashable {
        // TNG Tricorder sounds
        case tricorderOpen = "tng_tricorder_open"
        case tricorder1 = "tng_tricorder1"
        case tricorder2 = "tng_tricorder2"
        case tricorder3 = "tng_tricorder3"
        case tricorder4 = "tng_tricorder4"
        case tricorder5 = "tng_tricorder5"
        case tricorder6 = "tng_tricorder6"
        case tricorder7 = "tng_tricorder7"
        case tricorder8 = "tng_tricorder8"
        case tricorder9 = "tng_tricorder9"
        case tricorder10 = "tng_tricorder10"
        case tricorder11 = "tng_tricorder11"
        case tricorder12 = "tng_tricorder12"

        // TNG Viewscreen
        case viewscreenOn = "tng_viewscreen_on"
        case viewscreenOff = "tng_viewscreen_off"

        // DS9 Tricorder
        case ds9Tricorder1 = "ds9_tricorder_1"
        case ds9Tricorder2 = "ds9_tricorder_2"
        case ds9Tricorder3 = "ds9_tricorder_3"

        // TOS Classic
        case tosTricorderScan = "tos_tricorder_scan"
        case tosTricorderAlert = "tos_tricoder_alert"
        case tosViewscreen = "tos_main_viewing_screen"
        case tosViewscreenMagnification = "tos_viewscreen_magnification"

        // Enterprise
        case entScreen1 = "ent_screen01"
        case entScreen2 = "ent_screen02"
        case entScreen3 = "ent_screen3"
        case entScreen4 = "ent_screen4"
        case entScreen5 = "ent_screen5"

        // TAS
        case tasViewscreen = "tas_viewscreen"

        var displayName: String {
            switch self {
            case .tricorderOpen: return "Tricorder Open"
            case .tricorder1, .tricorder2, .tricorder3, .tricorder4, .tricorder5,
                 .tricorder6, .tricorder7, .tricorder8, .tricorder9, .tricorder10,
                 .tricorder11, .tricorder12:
                return "TNG Tricorder"
            case .viewscreenOn: return "Screen On"
            case .viewscreenOff: return "Screen Off"
            case .ds9Tricorder1, .ds9Tricorder2, .ds9Tricorder3:
                return "DS9 Tricorder"
            case .tosTricorderScan: return "TOS Scan"
            case .tosTricorderAlert: return "TOS Alert"
            case .tosViewscreen: return "TOS Screen"
            case .tosViewscreenMagnification: return "TOS Magnify"
            case .entScreen1, .entScreen2, .entScreen3, .entScreen4, .entScreen5:
                return "ENT Screen"
            case .tasViewscreen: return "TAS Screen"
            }
        }

        var category: SoundCategory {
            switch self {
            case .tricorderOpen, .tricorder1, .tricorder2, .tricorder3, .tricorder4,
                 .tricorder5, .tricorder6, .tricorder7, .tricorder8, .tricorder9,
                 .tricorder10, .tricorder11, .tricorder12, .ds9Tricorder1, .ds9Tricorder2,
                 .ds9Tricorder3, .tosTricorderScan, .tosTricorderAlert:
                return .tricorder
            case .viewscreenOn, .viewscreenOff, .tosViewscreen, .tosViewscreenMagnification,
                 .entScreen1, .entScreen2, .entScreen3, .entScreen4, .entScreen5,
                 .tasViewscreen:
                return .interface
            }
        }
    }

    enum SoundCategory: String, CaseIterable {
        case tricorder = "Tricorder"
        case interface = "Interface"
    }

    // MARK: - Initialization

    private init() {
        preloadSounds()
    }

    // MARK: - Public Methods

    func play(_ sound: LCARSSound) {
        guard isEnabled else { return }

        lock.lock()
        defer { lock.unlock() }

        if let player = audioPlayers[sound.rawValue] {
            player.volume = volume
            player.currentTime = 0
            player.play()
        }
    }

    func stop(_ sound: LCARSSound) {
        lock.lock()
        defer { lock.unlock() }

        audioPlayers[sound.rawValue]?.stop()
    }

    func stopAll() {
        lock.lock()
        defer { lock.unlock() }

        audioPlayers.values.forEach { $0.stop() }
    }

    // MARK: - Private Methods

    private func preloadSounds() {
        for sound in LCARSSound.allCases {
            guard let url = Bundle.main.url(forResource: sound.rawValue, withExtension: "mp3") else {
                print("⚠️ Sound not found: \(sound.rawValue)")
                continue
            }

            do {
                let player = try AVAudioPlayer(contentsOf: url)
                player.prepareToPlay()
                audioPlayers[sound.rawValue] = player
            } catch {
                print("⚠️ Failed to load sound \(sound.rawValue): \(error)")
            }
        }
    }
}

// MARK: - SwiftUI View Extension

extension View {
    /// Plays an LCARS sound effect
    func playLCARSSound(_ sound: LCARSSoundManager.LCARSSound) -> some View {
        self.onAppear {
            LCARSSoundManager.shared.play(sound)
        }
    }

    /// Plays sound on button tap with haptic feedback
    func withLCARSFeedback(sound: LCARSSoundManager.LCARSSound = .tricorder1) -> some View {
        self.sensoryFeedback(.impact(flexibility: .soft, intensity: 0.7), trigger: UUID())
            .onTapGesture {
                LCARSSoundManager.shared.play(sound)
            }
    }
}
