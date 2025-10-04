//
//  LCARSBar.swift
//  ComponentLibrary
//
//  Created by Clifton Baggerman on 04/10/2025.
//

import SwiftUI

/// LCARS bar - horizontal or vertical bar element
public struct LCARSBar: View {

    // MARK: - Properties

    private let orientation: Orientation
    private let color: Color
    private let length: CGFloat
    private let thickness: CGFloat
    private let label: String?

    // MARK: - Initialization

    public init(
        orientation: Orientation = .horizontal,
        color: Color = .lcarOrange,
        length: CGFloat = 200,
        thickness: CGFloat = 30,
        label: String? = nil
    ) {
        self.orientation = orientation
        self.color = color
        self.length = length
        self.thickness = thickness
        self.label = label
    }

    // MARK: - Body

    public var body: some View {
        ZStack {
            Rectangle()
                .fill(color)
                .frame(
                    width: orientation == .horizontal ? length : thickness,
                    height: orientation == .horizontal ? thickness : length
                )

            if let label = label {
                Text(label)
                    .font(.custom("HelveticaNeue-CondensedBold", size: 12))
                    .foregroundStyle(Color.lcarBlack)
                    .scaleEffect(x: 0.8, anchor: .center)
                    .rotationEffect(.degrees(orientation == .vertical ? -90 : 0))
            }
        }
    }
}

// MARK: - Orientation

extension LCARSBar {
    public enum Orientation {
        case horizontal
        case vertical
    }
}

// MARK: - Preview

#Preview("LCARS Bars") {
    ZStack {
        Color.lcarBlack
            .ignoresSafeArea()

        VStack(spacing: 30) {
            // Horizontal bars
            VStack(spacing: 12) {
                LCARSBar(
                    orientation: .horizontal,
                    color: .lcarOrange,
                    length: 300,
                    label: "SYSTEMS 01-847293"
                )

                LCARSBar(
                    orientation: .horizontal,
                    color: .lcarViolet,
                    length: 250,
                    thickness: 40,
                    label: "POWER 02-562918"
                )

                LCARSBar(
                    orientation: .horizontal,
                    color: .lcarPink,
                    length: 200,
                    thickness: 25
                )
            }

            Divider()
                .background(Color.lcarWhite.opacity(0.3))
                .padding(.horizontal, 40)

            // Vertical bars
            HStack(spacing: 20) {
                LCARSBar(
                    orientation: .vertical,
                    color: .lcarTan,
                    length: 150,
                    thickness: 30,
                    label: "STATUS"
                )

                LCARSBar(
                    orientation: .vertical,
                    color: .lcarLightOrange,
                    length: 180,
                    thickness: 35,
                    label: "SENSOR"
                )

                LCARSBar(
                    orientation: .vertical,
                    color: .lcarPlum,
                    length: 120,
                    thickness: 25
                )
            }
        }
    }
}
