//
//  LCARSUtilities.swift
//  LCARSComponents
//
//  Created by Clifton Baggerman on 04/10/2025.
//

import Foundation

// MARK: - LCARS Utilities

/// Shared utilities for LCARS design system
public enum LCARSUtilities {

    /// Generate random digits string
    /// - Parameter count: Number of digits to generate
    /// - Returns: String of random digits
    public static func randomDigits(_ count: Int) -> String {
        (1...count).map { _ in "\(Int.random(in: 0...9))" }.joined()
    }

    /// Generate LCARS identifier code
    /// - Parameters:
    ///   - prefix: Prefix for the identifier (e.g., "LCARS", "SYS", "DAT")
    ///   - digits: Number of digits (default: 5)
    /// - Returns: Formatted LCARS code
    public static func lcarCode(prefix: String = "LCARS", digits: Int = 5) -> String {
        "\(prefix) \(randomDigits(digits))"
    }

    /// Generate numbered system code
    /// - Parameters:
    ///   - section: Section number (e.g., "02", "03")
    ///   - digits: Number of digits (default: 6)
    /// - Returns: Formatted system code
    public static func systemCode(section: String, digits: Int = 6) -> String {
        "\(section)-\(randomDigits(digits))"
    }

    /// Generate digits derived from a seed, so a label reads the same on every redraw
    /// - Parameters:
    ///   - seed: Any text that identifies what the digits decorate
    ///   - count: Number of digits to generate
    /// - Returns: String of digits that is stable for the seed
    public static func stableDigits(_ seed: String, count: Int) -> String {
        var hash: UInt64 = 0xcbf29ce484222325
        for byte in seed.utf8 {
            hash = (hash ^ UInt64(byte)) &* 0x100000001b3
        }

        var digits = ""
        for _ in 0..<count {
            hash = hash &* 6364136223846793005 &+ 1442695040888963407
            digits.append(String((hash >> 33) % 10))
        }
        return digits
    }
}
