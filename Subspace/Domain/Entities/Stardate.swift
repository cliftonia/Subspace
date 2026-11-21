//
//  Stardate.swift
//  Subspace
//
//  Created by Clifton Baggerman on 30/10/2026.
//

import Foundation

/// Converts calendar dates to TNG-style stardates, at one thousand units per year
nonisolated enum Stardate {
    private static let epochYear = 1982

    /// Formats a date as a stardate
    /// - Parameters:
    ///   - date: The date to convert
    ///   - calendar: The calendar used to find the position within the year
    /// - Returns: The stardate to one decimal place
    static func string(for date: Date, calendar: Calendar = .current) -> String {
        let year = calendar.component(.year, from: date)
        let dayOfYear = calendar.ordinality(of: .day, in: .year, for: date) ?? 1
        let daysInYear = calendar.range(of: .day, in: .year, for: date)?.count ?? 365
        let stardate = Double(year - epochYear) * 1000 + Double(dayOfYear - 1) / Double(daysInYear) * 1000

        return String(format: "%.1f", stardate)
    }
}
