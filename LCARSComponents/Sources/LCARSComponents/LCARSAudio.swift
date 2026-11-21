//
//  LCARSAudio.swift
//  LCARSComponents
//
//  Created by Clifton Baggerman on 30/10/2026.
//

import AVFoundation
import os

/// Plays LCARS interface sounds alongside any other audio on the device
@MainActor
public final class LCARSAudio {

    // MARK: - Sound

    public enum Sound: String, CaseIterable, Sendable {
        case tap = "ent_screen02"
        case key = "ent_screen3"
        case confirm = "tng_tricorder_open"
        case open = "tng_viewscreen_on"
        case alert = "tos_tricoder_alert"
    }

    // MARK: - Properties

    public static let shared = LCARSAudio()

    /// The defaults key that switches interface sounds on and off
    public static let enabledKey = "lcars.soundEnabled"

    private let logger = Logger(subsystem: "LCARSComponents", category: "LCARSAudio")
    private var players: [Sound: AVAudioPlayer] = [:]
    private var isSessionConfigured = false

    // MARK: - Initialization

    private init() {}

    // MARK: - Public Methods

    /// Plays a sound from the start, unless interface sounds are switched off
    public func play(_ sound: Sound) {
        guard UserDefaults.standard.object(forKey: Self.enabledKey) as? Bool ?? true else {
            return
        }

        configureSessionIfNeeded()

        guard let player = player(for: sound) else {
            return
        }

        player.currentTime = 0
        if !player.play() {
            logger.error("Could not play sound: \(sound.rawValue, privacy: .public)")
        }
    }

    // MARK: - Resources

    nonisolated static func hasResource(for sound: Sound) -> Bool {
        resourceURL(for: sound) != nil
    }

    /// Decodes a sound and returns its loudest sample, from 0 for silence to 1 for full scale
    nonisolated static func peakLevel(of sound: Sound) throws -> Float {
        guard let url = resourceURL(for: sound) else {
            return 0
        }

        let file = try AVAudioFile(forReading: url)
        let capacity = AVAudioFrameCount(file.length)
        guard let buffer = AVAudioPCMBuffer(pcmFormat: file.processingFormat, frameCapacity: capacity) else {
            return 0
        }

        try file.read(into: buffer)
        guard let samples = buffer.floatChannelData?[0] else {
            return 0
        }

        return (0..<Int(buffer.frameLength)).reduce(0) { max($0, abs(samples[$1])) }
    }

    private nonisolated static func resourceURL(for sound: Sound) -> URL? {
        Bundle.module.url(forResource: sound.rawValue, withExtension: "mp3")
    }

    // MARK: - Private Methods

    private func player(for sound: Sound) -> AVAudioPlayer? {
        if let player = players[sound] {
            return player
        }

        guard let url = Self.resourceURL(for: sound) else {
            logger.error("Missing sound: \(sound.rawValue, privacy: .public)")
            return nil
        }

        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.volume = 0.5
            player.prepareToPlay()
            players[sound] = player
            return player
        } catch {
            logger.error("Could not load sound: \(error.localizedDescription, privacy: .public)")
            return nil
        }
    }

    private func configureSessionIfNeeded() {
        guard !isSessionConfigured else {
            return
        }

        isSessionConfigured = true
        try? AVAudioSession.sharedInstance().setCategory(.ambient, options: .mixWithOthers)
    }
}
