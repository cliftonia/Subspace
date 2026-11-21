//
//  LCARSSections.swift
//  LCARSComponents
//
//  Created by Clifton Baggerman on 30/10/2026.
//

import SwiftUI

// MARK: - Section Header

/// Section title seated in a rail, with a stable reference code at its far end
public struct LCARSSectionHeader: View {

    // MARK: - Properties

    private let title: String
    private let color: Color

    // MARK: - Initialization

    public init(_ title: String, color: Color = .lcarOrange) {
        self.title = title
        self.color = color
    }

    // MARK: - Body

    public var body: some View {
        HStack(spacing: 6) {
            UnevenRoundedRectangle(topLeadingRadius: 7, bottomLeadingRadius: 7)
                .fill(color)
                .frame(width: 18, height: 14)
                .accessibilityHidden(true)

            Text(title.uppercased())
                .font(.lcars(20, relativeTo: .headline))
                .foregroundStyle(color)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                .layoutPriority(1)
                .accessibilityAddTraits(.isHeader)

            color
                .frame(height: 14)
                .accessibilityHidden(true)

            Text(LCARSUtilities.stableDigits(title, count: 3))
                .font(.lcars(16))
                .foregroundStyle(color)
                .dynamicTypeSize(...LCARSMetrics.chromeTypeLimit)
                .accessibilityHidden(true)
        }
    }
}

// MARK: - Readout Row

/// A labelled value, with the label seated in a block of colour
public struct LCARSReadoutRow: View {

    // MARK: - Properties

    private let label: String
    private let value: String
    private let color: Color

    // MARK: - Initialization

    public init(label: String, value: String, color: Color = .lcarViolet) {
        self.label = label
        self.value = value
        self.color = color
    }

    // MARK: - Body

    public var body: some View {
        HStack(spacing: 8) {
            Text(label.uppercased())
                .font(.lcars(16))
                .foregroundStyle(Color.lcarBlack)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                .dynamicTypeSize(...LCARSMetrics.chromeTypeLimit)
                .padding(.horizontal, 8)
                .frame(width: 84, height: 30, alignment: .trailing)
                .background(UnevenRoundedRectangle(topLeadingRadius: 15, bottomLeadingRadius: 15).fill(color))

            Text(value)
                .font(.lcarsBody(16))
                .foregroundStyle(Color.lcarWhite)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .accessibilityElement(children: .combine)
    }
}

// MARK: - Data Cascade

/// The columns of drifting numbers seen on LCARS screens. Purely decorative.
public struct LCARSDataCascade: View {

    // MARK: - Constants

    private static let interval: TimeInterval = 1.4

    // MARK: - Properties

    @Environment(\.accessibilityReduceMotion)
    private var reduceMotion

    private let seed: String
    private let rows: Int
    private let colors: [Color]

    // MARK: - Initialization

    public init(seed: String, rows: Int = 4, colors: [Color] = [.lcarOrange, .lcarViolet, .lcarTan, .lcarPink]) {
        self.seed = seed
        self.rows = rows
        self.colors = colors
    }

    // MARK: - Body

    public var body: some View {
        TimelineView(.periodic(from: .now, by: Self.interval)) { context in
            let tick = reduceMotion ? 0 : Int(context.date.timeIntervalSinceReferenceDate / Self.interval)

            Grid(alignment: .trailing, horizontalSpacing: 10, verticalSpacing: 2) {
                ForEach(0..<rows, id: \.self) { row in
                    GridRow {
                        ForEach(colors.indices, id: \.self) { column in
                            Text(digits(row: row, column: column, tick: tick))
                                .font(.lcars(17))
                                .foregroundStyle(colors[column])
                                .dynamicTypeSize(...LCARSMetrics.chromeTypeLimit)
                        }
                    }
                }
            }
            .accessibilityHidden(true)
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
    }

    // MARK: - Private Methods

    /// Lets each cell change at its own pace, so the columns ripple instead of flashing together
    private func digits(row: Int, column: Int, tick: Int) -> String {
        let pace = 1 + (row + column * 2) % 4
        return LCARSUtilities.stableDigits("\(seed)-\(row)-\(column)-\(tick / pace)", count: 4 + column % 3)
    }
}
