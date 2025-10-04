//
//  LCARSUtilities.swift
//  ComponentLibrary
//
//  Created by Clifton Baggerman on 04/10/2025.
//

import Foundation

/// Utility functions for LCARS components
public enum LCARSUtilities {

    /// Generate random digits for LCARS codes
    /// - Parameter count: Number of digits to generate
    /// - Returns: String of random digits
    public static func randomDigits(_ count: Int) -> String {
        (1...count).map { _ in "\(Int.random(in: 0...9))" }.joined()
    }

    /// Generate LCARS code with prefix
    /// - Parameters:
    ///   - prefix: Code prefix (default: "LCARS")
    ///   - digits: Number of digits (default: 5)
    /// - Returns: Formatted LCARS code
    public static func lcarCode(prefix: String = "LCARS", digits: Int = 5) -> String {
        "\(prefix) \(randomDigits(digits))"
    }

    /// Generate system code with section and digits
    /// - Parameters:
    ///   - section: Section identifier
    ///   - digits: Number of digits (default: 6)
    /// - Returns: Formatted system code
    public static func systemCode(section: String, digits: Int = 6) -> String {
        "\(section)-\(randomDigits(digits))"
    }
}
