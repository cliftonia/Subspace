//
//  LCARSElbow.swift
//  LCARSComponents
//
//  Created by Clifton Baggerman on 04/10/2025.
//

import SwiftUI

/// The signature LCARS form: a broad arm sweeping into a thin rail.
///
/// The outer and inner bends are independent quarter circles, so the arm and rail can differ
/// in thickness without the curve collapsing into a rounded rectangle. Dimensions are clamped
/// to the available rect, so the shape stays continuous at any size.
public struct LCARSElbow: Shape {

    // MARK: - Corner

    /// The corner of the rect that the outer bend occupies
    public enum Corner: Sendable, CaseIterable {
        case topLeading
        case topTrailing
        case bottomLeading
        case bottomTrailing
    }

    // MARK: - Properties

    private let corner: Corner
    private let armWidth: CGFloat
    private let railHeight: CGFloat
    private let outerRadius: CGFloat
    private let innerRadius: CGFloat

    // MARK: - Initialization

    public init(
        corner: Corner,
        armWidth: CGFloat,
        railHeight: CGFloat,
        outerRadius: CGFloat,
        innerRadius: CGFloat
    ) {
        self.corner = corner
        self.armWidth = armWidth
        self.railHeight = railHeight
        self.outerRadius = outerRadius
        self.innerRadius = innerRadius
    }

    // MARK: - Shape

    public func path(in rect: CGRect) -> Path {
        let width = rect.width
        let height = rect.height
        guard width > 0, height > 0 else {
            return Path()
        }

        let arm = min(armWidth, width)
        let rail = min(railHeight, height)
        let outer = min(outerRadius, width, height)
        let inner = min(innerRadius, width - arm, height - rail)

        var path = Path()
        path.move(to: CGPoint(x: 0, y: height))
        path.addLine(to: CGPoint(x: 0, y: outer))
        path.addArc(
            center: CGPoint(x: outer, y: outer),
            radius: outer,
            startAngle: .degrees(180),
            endAngle: .degrees(270),
            clockwise: false
        )
        path.addLine(to: CGPoint(x: width, y: 0))
        path.addLine(to: CGPoint(x: width, y: rail))
        path.addLine(to: CGPoint(x: arm + inner, y: rail))
        path.addArc(
            center: CGPoint(x: arm + inner, y: rail + inner),
            radius: inner,
            startAngle: .degrees(270),
            endAngle: .degrees(180),
            clockwise: true
        )
        path.addLine(to: CGPoint(x: arm, y: height))
        path.closeSubpath()

        return path.applying(orientationTransform(width: width, height: height, origin: rect.origin))
    }

    // MARK: - Private Methods

    /// The path is drawn for the top leading corner, then mirrored into place
    private func orientationTransform(width: CGFloat, height: CGFloat, origin: CGPoint) -> CGAffineTransform {
        let flipsHorizontally = corner == .topTrailing || corner == .bottomTrailing
        let flipsVertically = corner == .bottomLeading || corner == .bottomTrailing

        return CGAffineTransform(
            a: flipsHorizontally ? -1 : 1,
            b: 0,
            c: 0,
            d: flipsVertically ? -1 : 1,
            tx: origin.x + (flipsHorizontally ? width : 0),
            ty: origin.y + (flipsVertically ? height : 0)
        )
    }
}

// MARK: - Preview

#Preview("LCARS Elbows") {
    VStack(spacing: 12) {
        LCARSElbow(corner: .bottomLeading, armWidth: 96, railHeight: 16, outerRadius: 56, innerRadius: 28)
            .fill(Color.lcarOrange)
        LCARSElbow(corner: .topLeading, armWidth: 96, railHeight: 16, outerRadius: 56, innerRadius: 28)
            .fill(Color.lcarViolet)
    }
    .padding(16)
    .background(Color.lcarBlack)
}
