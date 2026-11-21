//
//  LCARSWeightedRow.swift
//  LCARSComponents
//
//  Created by Clifton Baggerman on 30/10/2026.
//

import SwiftUI

/// Lays out subviews in a row, sharing the width in proportion to their weights
public struct LCARSWeightedRow: Layout {

    // MARK: - Properties

    private let weights: [CGFloat]
    private let spacing: CGFloat

    // MARK: - Initialization

    public init(weights: [CGFloat], spacing: CGFloat = LCARSMetrics.gutter) {
        self.weights = weights
        self.spacing = spacing
    }

    // MARK: - Layout

    public func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let tallest = subviews.map { $0.sizeThatFits(.unspecified).height }.max() ?? 0
        return CGSize(width: proposal.width ?? 0, height: proposal.height ?? tallest)
    }

    public func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let widths = Self.widths(for: weights, available: bounds.width, spacing: spacing)
        var originX = bounds.minX

        for (subview, width) in zip(subviews, widths) {
            subview.place(
                at: CGPoint(x: originX, y: bounds.minY),
                proposal: ProposedViewSize(width: width, height: bounds.height)
            )
            originX += width + spacing
        }
    }

    // MARK: - Measurement

    /// Calculates the width of each slot once the gaps between them are removed
    static func widths(for weights: [CGFloat], available: CGFloat, spacing: CGFloat) -> [CGFloat] {
        let totalWeight = weights.reduce(0, +)
        guard totalWeight > 0 else {
            return []
        }

        let gaps = spacing * CGFloat(weights.count - 1)
        let usable = max(available - gaps, 0)
        return weights.map { usable * $0 / totalWeight }
    }
}
