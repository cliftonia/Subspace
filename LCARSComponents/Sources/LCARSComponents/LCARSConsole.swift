//
//  LCARSConsole.swift
//  LCARSComponents
//
//  Created by Clifton Baggerman on 30/10/2026.
//

import SwiftUI

// MARK: - Metrics

/// Shared proportions of the LCARS frame
public enum LCARSMetrics {
    public static let gutter: CGFloat = 4
    public static let armWidth: CGFloat = 92
    public static let railHeight: CGFloat = 16
    public static let elbowWidth: CGFloat = 148
    public static let elbowHeight: CGFloat = 64
    public static let outerRadius: CGFloat = 56
    public static let innerRadius: CGFloat = 26
    public static let headerHeight: CGFloat = 84
    public static let contentInset: CGFloat = 12

    /// The largest type size for labels seated in fixed blocks of colour, which cannot grow without clipping
    public static let chromeTypeLimit = DynamicTypeSize.xxxLarge
}

// MARK: - Header

/// What the console displays above its content
public struct LCARSConsoleHeader {
    let title: String
    let code: String
    let accent: Color
    let secondary: Color
    let railColors: [Color]

    public init(title: String, code: String, accent: Color, secondary: Color, railColors: [Color]) {
        self.title = title
        self.code = code
        self.accent = accent
        self.secondary = secondary
        self.railColors = railColors
    }
}

// MARK: - Console

/// The LCARS frame: two opposed elbows, with navigation in the arm and content beside it
public struct LCARSConsole<Navigation: View, Content: View>: View {

    // MARK: - Properties

    private let header: LCARSConsoleHeader
    private let navigation: Navigation
    private let content: Content

    // MARK: - Initialization

    public init(
        header: LCARSConsoleHeader,
        @ViewBuilder navigation: () -> Navigation,
        @ViewBuilder content: () -> Content
    ) {
        self.header = header
        self.navigation = navigation()
        self.content = content()
    }

    // MARK: - Body

    public var body: some View {
        VStack(spacing: LCARSMetrics.gutter) {
            headerBand
            mainBand
        }
        .background(Color.lcarBlack.ignoresSafeArea())
    }

    // MARK: - Header Band

    private var headerBand: some View {
        HStack(alignment: .bottom, spacing: LCARSMetrics.gutter) {
            Text(header.code)
                .font(.lcars(16))
                .foregroundStyle(Color.lcarBlack)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                .dynamicTypeSize(...LCARSMetrics.chromeTypeLimit)
                .padding(.trailing, 8)
                .padding(.bottom, LCARSMetrics.railHeight + 8)
                .frame(maxHeight: .infinity, alignment: .bottom)
                .frame(width: LCARSMetrics.armWidth, alignment: .trailing)
                .frame(width: LCARSMetrics.elbowWidth, alignment: .leading)
                .background {
                    elbow(.bottomLeading)
                        .fill(header.accent)
                        .ignoresSafeArea(edges: .top)
                }

            VStack(alignment: .trailing, spacing: LCARSMetrics.gutter) {
                Text(header.title)
                    .font(.lcars(40, relativeTo: .largeTitle))
                    .foregroundStyle(header.accent)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .dynamicTypeSize(...LCARSMetrics.chromeTypeLimit)
                    .accessibilityAddTraits(.isHeader)
                    .frame(maxHeight: .infinity, alignment: .bottom)
                    .padding(.trailing, LCARSMetrics.contentInset)

                LCARSRail(colors: header.railColors)
            }
        }
        .frame(height: LCARSMetrics.headerHeight)
    }

    // MARK: - Main Band

    private var mainBand: some View {
        ZStack(alignment: .topLeading) {
            HStack(alignment: .top, spacing: LCARSMetrics.gutter) {
                elbow(.topLeading)
                    .fill(header.secondary)
                    .frame(width: LCARSMetrics.elbowWidth, height: LCARSMetrics.elbowHeight)

                LCARSRail(colors: header.railColors.reversed())
            }

            HStack(alignment: .top, spacing: LCARSMetrics.contentInset) {
                navigationColumn
                    .frame(width: LCARSMetrics.armWidth)
                    .padding(.top, LCARSMetrics.elbowHeight + LCARSMetrics.gutter)

                content
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    .padding(.top, LCARSMetrics.railHeight + LCARSMetrics.contentInset)
                    .padding(.trailing, LCARSMetrics.contentInset)
            }
        }
    }

    /// Scrolls the buttons only when the window is too short to show them all
    private var navigationColumn: some View {
        ViewThatFits(in: .vertical) {
            VStack(spacing: LCARSMetrics.gutter) {
                navigation

                header.secondary
                    .frame(minHeight: LCARSMetrics.railHeight)
                    .ignoresSafeArea(edges: .bottom)
                    .accessibilityHidden(true)
            }

            ScrollView(showsIndicators: false) {
                VStack(spacing: LCARSMetrics.gutter) {
                    navigation
                }
            }
        }
    }

    // MARK: - Private Methods

    private func elbow(_ corner: LCARSElbow.Corner) -> LCARSElbow {
        LCARSElbow(
            corner: corner,
            armWidth: LCARSMetrics.armWidth,
            railHeight: LCARSMetrics.railHeight,
            outerRadius: LCARSMetrics.outerRadius,
            innerRadius: LCARSMetrics.innerRadius
        )
    }
}

// MARK: - Arm Blocks

/// Decorative blocks that fill the arm of the frame on screens without navigation
public struct LCARSArmBlocks: View {

    // MARK: - Types

    private struct Block: Identifiable {
        let id: Int
        let color: Color
        let height: CGFloat
    }

    private static let blocks = [
        Block(id: 1, color: .lcarViolet, height: 56),
        Block(id: 2, color: .lcarOrange, height: 96),
        Block(id: 3, color: .lcarTan, height: 40),
        Block(id: 4, color: .lcarBlue, height: 72)
    ]

    // MARK: - Properties

    private let seed: String

    // MARK: - Initialization

    public init(seed: String) {
        self.seed = seed
    }

    // MARK: - Body

    public var body: some View {
        ForEach(Self.blocks) { block in
            Text("\(block.id)-\(LCARSUtilities.stableDigits("\(seed)\(block.id)", count: 4))")
                .font(.lcars(16))
                .foregroundStyle(Color.lcarBlack)
                .padding(.trailing, 8)
                .padding(.bottom, 4)
                .frame(maxWidth: .infinity, alignment: .bottomTrailing)
                .frame(height: block.height, alignment: .bottom)
                .background(block.color)
                .accessibilityHidden(true)
        }
    }
}

// MARK: - Rail

/// A horizontal run of coloured segments, finished with a rounded end cap
public struct LCARSRail: View {

    // MARK: - Properties

    private let colors: [Color]

    // MARK: - Initialization

    public init(colors: [Color]) {
        self.colors = colors
    }

    // MARK: - Body

    public var body: some View {
        LCARSWeightedRow(weights: weights) {
            ForEach(Array(colors.enumerated()), id: \.offset) { index, color in
                UnevenRoundedRectangle(
                    bottomTrailingRadius: index == colors.count - 1 ? LCARSMetrics.railHeight / 2 : 0,
                    topTrailingRadius: index == colors.count - 1 ? LCARSMetrics.railHeight / 2 : 0
                )
                .fill(color)
            }
        }
        .frame(height: LCARSMetrics.railHeight)
        .accessibilityHidden(true)
    }

    /// Alternates broad and narrow segments, the rhythm of a real LCARS rail
    private var weights: [CGFloat] {
        colors.indices.map { $0.isMultiple(of: 2) ? 3 : 1 }
    }
}
