//
//  LCARSUtilities.swift
//  Subspace
//
//  Created by Clifton Baggerman on 04/10/2025.
//

import Foundation

// MARK: - LCARS Utilities

/// Shared utilities for LCARS design system
enum LCARSUtilities {

    /// Generate random digits string
    /// - Parameter count: Number of digits to generate
    /// - Returns: String of random digits
    static func randomDigits(_ count: Int) -> String {
        (1...count).map { _ in "\(Int.random(in: 0...9))" }.joined()
    }

    /// Generate LCARS identifier code
    /// - Parameters:
    ///   - prefix: Prefix for the identifier (e.g., "LCARS", "SYS", "DAT")
    ///   - digits: Number of digits (default: 5)
    /// - Returns: Formatted LCARS code
    static func lcarCode(prefix: String = "LCARS", digits: Int = 5) -> String {
        "\(prefix) \(randomDigits(digits))"
    }

    /// Generate numbered system code
    /// - Parameters:
    ///   - section: Section number (e.g., "02", "03")
    ///   - digits: Number of digits (default: 6)
    /// - Returns: Formatted system code
    static func systemCode(section: String, digits: Int = 6) -> String {
        "\(section)-\(randomDigits(digits))"
    }
}
