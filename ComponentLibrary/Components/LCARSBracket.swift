//
//  LCARSBracket.swift
//  ComponentLibrary
//
//  Created by Clifton Baggerman on 04/10/2025.
//

import SwiftUI

/// LCARS bracket - decorative frame for grouping elements
public struct LCARSBracket<Content: View>: View {

    // MARK: - Properties

    private let color: Color
    private let thickness: CGFloat
    private let cornerRadius: CGFloat
    private let spacing: CGFloat
    private let label: String?
    private let content: Content

    // MARK: - Initialization

    public init(
        color: Color = .lcarOrange,
        thickness: CGFloat = 8,
        cornerRadius: CGFloat = 20,
        spacing: CGFloat = 16,
        label: String? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.color = color
        self.thickness = thickness
        self.cornerRadius = cornerRadius
        self.spacing = spacing
        self.label = label
        self.content = content()
    }

    // MARK: - Body

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Top label if provided
            if let label = label {
                Text(label)
                    .font(.custom("HelveticaNeue-CondensedBold", size: 16))
                    .foregroundStyle(color)
                    .padding(.bottom, 8)
            }

            // Content with bracket frame
            content
                .padding(spacing)
                .background {
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .strokeBorder(color, lineWidth: thickness)
                }
        }
    }
}

// MARK: - Corner Bracket Variant

/// LCARS corner bracket - L-shaped bracket for corner decoration
public struct LCARSCornerBracket: View {

    // MARK: - Properties

    private let position: CornerPosition
    private let color: Color
    private let length: CGFloat
    private let thickness: CGFloat
    private let cornerRadius: CGFloat

    // MARK: - Initialization

    public init(
        position: CornerPosition,
        color: Color = .lcarOrange,
        length: CGFloat = 80,
        thickness: CGFloat = 8,
        cornerRadius: CGFloat = 20
    ) {
        self.position = position
        self.color = color
        self.length = length
        self.thickness = thickness
        self.cornerRadius = cornerRadius
    }

    // MARK: - Body

    public var body: some View {
        Canvas { context, size in
            let path = createBracketPath(size: size)
            context.stroke(
                path,
                with: .color(color),
                lineWidth: thickness
            )
        }
        .frame(width: length, height: length)
    }

    private func createBracketPath(size: CGSize) -> Path {
        var path = Path()

        switch position {
        case .topLeading:
            path.move(to: CGPoint(x: size.width, y: cornerRadius))
            path.addArc(
                center: CGPoint(x: cornerRadius, y: cornerRadius),
                radius: cornerRadius,
                startAngle: .degrees(0),
                endAngle: .degrees(90),
                clockwise: false
            )
            path.addLine(to: CGPoint(x: cornerRadius, y: size.height))

        case .topTrailing:
            path.move(to: CGPoint(x: 0, y: cornerRadius))
            path.addArc(
                center: CGPoint(x: size.width - cornerRadius, y: cornerRadius),
                radius: cornerRadius,
                startAngle: .degrees(180),
                endAngle: .degrees(90),
                clockwise: true
            )
            path.addLine(to: CGPoint(x: size.width - cornerRadius, y: size.height))

        case .bottomLeading:
            path.move(to: CGPoint(x: size.width, y: size.height - cornerRadius))
            path.addArc(
                center: CGPoint(x: cornerRadius, y: size.height - cornerRadius),
                radius: cornerRadius,
                startAngle: .degrees(0),
                endAngle: .degrees(270),
                clockwise: true
            )
            path.addLine(to: CGPoint(x: cornerRadius, y: 0))

        case .bottomTrailing:
            path.move(to: CGPoint(x: 0, y: size.height - cornerRadius))
            path.addArc(
                center: CGPoint(x: size.width - cornerRadius, y: size.height - cornerRadius),
                radius: cornerRadius,
                startAngle: .degrees(180),
                endAngle: .degrees(270),
                clockwise: false
            )
            path.addLine(to: CGPoint(x: size.width - cornerRadius, y: 0))
        }

        return path
    }
}

// MARK: - Corner Position

public enum CornerPosition {
    case topLeading
    case topTrailing
    case bottomLeading
    case bottomTrailing
}

// MARK: - Preview

#Preview("LCARS Brackets") {
    ZStack {
        Color.lcarBlack
            .ignoresSafeArea()

        ScrollView {
            VStack(spacing: 30) {
                // Full bracket with content
                LCARSBracket(
                    color: .lcarOrange,
                    label: "SYSTEMS CONTROL"
                ) {
                    VStack(spacing: 12) {
                        Text("Main Power: Online")
                            .foregroundStyle(Color.lcarWhite)
                        Text("Shields: 100%")
                            .foregroundStyle(Color.lcarWhite)
                        Text("Weapons: Armed")
                            .foregroundStyle(Color.lcarWhite)
                    }
                    .font(.custom("HelveticaNeue-CondensedBold", size: 14))
                }
                .padding(.horizontal, 20)

                // Corner brackets
                HStack(spacing: 100) {
                    LCARSCornerBracket(
                        position: .topLeading,
                        color: .lcarViolet,
                        length: 60
                    )

                    LCARSCornerBracket(
                        position: .topTrailing,
                        color: .lcarPink,
                        length: 60
                    )
                }

                HStack(spacing: 100) {
                    LCARSCornerBracket(
                        position: .bottomLeading,
                        color: .lcarTan,
                        length: 60
                    )

                    LCARSCornerBracket(
                        position: .bottomTrailing,
                        color: .lcarLightOrange,
                        length: 60
                    )
                }
            }
            .padding(.vertical, 40)
        }
    }
}
