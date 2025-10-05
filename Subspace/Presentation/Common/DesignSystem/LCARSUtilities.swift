//
//  LCARSUtilities.swift
//  Subspace
//
//  Created by Clifton Baggerman on 04/10/2025.
//

import SwiftUI

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

// MARK: - LCARS View Helpers

extension LCARSUtilities {

    /// Creates a common LCARS label with prefix and random digits
    /// - Parameters:
    ///   - prefix: The label prefix text (e.g., "APP", "SYS", "TMP")
    ///   - digits: Number of random digits (default: 4)
    /// - Returns: View displaying the LCARS-styled label
    static func commonLabel(prefix: String, digits: Int = 4) -> some View {
        HStack {
            Spacer()
            Text("\(prefix)-\(randomDigits(digits))")
                .font(.custom("HelveticaNeue-CondensedBold", size: 17))
                .foregroundStyle(Color.lcarBlack)
        }
        .frame(width: 90)
        .scaleEffect(x: 0.7, anchor: .trailing)
    }

    /// Creates an LCARS accent bar with segmented colors
    /// - Parameters:
    ///   - colors: Array of colors to display in the bar
    ///   - isTop: Whether this is the top or bottom accent bar (affects height behavior)
    /// - Returns: A view representing the accent bar
    static func accentBar(colors: [Color], isTop: Bool = true) -> some View {
        ZStack {
            Color.lcarBlack
            if isTop {
                HStack(spacing: 5) {
                    ForEach(0..<min(colors.count, 4), id: \.self) { index in
                        if index == 0 {
                            colors[index]
                                .frame(width: 20)
                                .padding(.leading, 5)
                        } else if index == 1 {
                            colors[index]
                                .frame(width: 50)
                        } else if index == colors.count - 1 {
                            colors[index]
                                .frame(width: 20)
                        } else {
                            colors[index]
                        }
                    }
                }
            } else {
                HStack(alignment: .top, spacing: 5) {
                    ForEach(0..<min(colors.count, 4), id: \.self) { index in
                        if index == 0 {
                            colors[index]
                                .frame(width: 20)
                                .padding(.leading, 5)
                        } else if index == 1 {
                            colors[index]
                                .frame(width: 50, height: 10)
                        } else if index == colors.count - 1 {
                            colors[index]
                                .frame(width: 20)
                        } else {
                            colors[index]
                        }
                    }
                }
            }
        }
        .frame(width: 200, height: 20)
    }

    /// Determines the height for a bottom frame color bar based on index
    /// - Parameters:
    ///   - index: The index of the color bar (0-based)
    ///   - total: Total number of labels (currently unused but available for future logic)
    /// - Returns: Height in points, or nil for flexible sizing
    static func frameHeight(for index: Int, total: Int) -> CGFloat? {
        switch index {
        case 0: return 100
        case 1: return 200
        case 2: return 50
        default: return nil
        }
    }

    /// Determines the alignment for label placement on color bars
    /// - Parameters:
    ///   - index: The index of the color bar (0-based)
    ///   - total: Total number of labels (currently unused but available for future logic)
    /// - Returns: SwiftUI alignment for label positioning
    static func labelAlignment(for index: Int, total: Int) -> Alignment {
        switch index {
        case 0: return .bottomLeading
        case 1: return .bottomLeading
        case 2: return .leading
        default: return .topLeading
        }
    }

    /// Calculates appropriate padding for labels on color bars
    /// - Parameters:
    ///   - index: The index of the color bar (0-based)
    ///   - total: Total number of labels (currently unused but available for future logic)
    /// - Returns: EdgeInsets for label padding
    static func labelPadding(for index: Int, total: Int) -> EdgeInsets {
        switch index {
        case 0, 1: return EdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 0)
        case 2: return EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        default: return EdgeInsets(top: 5, leading: 0, bottom: 0, trailing: 0)
        }
    }
}
