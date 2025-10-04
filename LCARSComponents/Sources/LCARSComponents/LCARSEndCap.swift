//
//  LCARSEndCap.swift
//  ComponentLibrary
//
//  Created by Clifton Baggerman on 04/10/2025.
//

import SwiftUI

/// LCARS end cap - rounded terminal for bars
public struct LCARSEndCap: View {

    // MARK: - Properties

    private let position: CapPosition
    private let color: Color
    private let size: CGSize
    private let label: String?

    // MARK: - Initialization

    public init(
        position: CapPosition,
        color: Color = .lcarOrange,
        size: CGSize = CGSize(width: 60, height: 30),
        label: String? = nil
    ) {
        self.position = position
        self.color = color
        self.size = size
        self.label = label
    }

    // MARK: - Body

    public var body: some View {
        ZStack {
            UnevenRoundedRectangle(
                topLeadingRadius: position.topLeading ? size.height / 2 : 0,
                bottomLeadingRadius: position.bottomLeading ? size.height / 2 : 0,
                bottomTrailingRadius: position.bottomTrailing ? size.height / 2 : 0,
                topTrailingRadius: position.topTrailing ? size.height / 2 : 0
            )
            .fill(color)
            .frame(width: size.width, height: size.height)

            if let label = label {
                Text(label)
                    .font(.custom("HelveticaNeue-CondensedBold", size: 10))
                    .foregroundStyle(Color.lcarBlack)
                    .scaleEffect(x: 0.8, anchor: .center)
            }
        }
    }
}

// MARK: - Cap Position

public enum CapPosition {
    case leading
    case trailing
    case top
    case bottom

    var topLeading: Bool {
        self == .leading || self == .top
    }

    var topTrailing: Bool {
        self == .trailing || self == .top
    }

    var bottomLeading: Bool {
        self == .leading || self == .bottom
    }

    var bottomTrailing: Bool {
        self == .trailing || self == .bottom
    }
}

// MARK: - Preview

#Preview("LCARS End Caps") {
    ZStack {
        Color.lcarBlack
            .ignoresSafeArea()

        VStack(spacing: 40) {
            // Horizontal end caps
            VStack(spacing: 16) {
                HStack(spacing: 0) {
                    LCARSEndCap(
                        position: .leading,
                        color: .lcarOrange,
                        label: "START"
                    )
                    LCARSBar(
                        orientation: .horizontal,
                        color: .lcarOrange,
                        length: 200,
                        thickness: 30
                    )
                    LCARSEndCap(
                        position: .trailing,
                        color: .lcarOrange,
                        label: "END"
                    )
                }

                HStack(spacing: 0) {
                    LCARSEndCap(
                        position: .leading,
                        color: .lcarViolet,
                        size: CGSize(width: 80, height: 40)
                    )
                    LCARSBar(
                        orientation: .horizontal,
                        color: .lcarViolet,
                        length: 150,
                        thickness: 40
                    )
                    LCARSEndCap(
                        position: .trailing,
                        color: .lcarViolet,
                        size: CGSize(width: 80, height: 40)
                    )
                }
            }

            // Vertical end caps
            HStack(spacing: 20) {
                VStack(spacing: 0) {
                    LCARSEndCap(
                        position: .top,
                        color: .lcarPink,
                        size: CGSize(width: 30, height: 60)
                    )
                    LCARSBar(
                        orientation: .vertical,
                        color: .lcarPink,
                        length: 120,
                        thickness: 30
                    )
                    LCARSEndCap(
                        position: .bottom,
                        color: .lcarPink,
                        size: CGSize(width: 30, height: 60)
                    )
                }

                VStack(spacing: 0) {
                    LCARSEndCap(
                        position: .top,
                        color: .lcarTan,
                        size: CGSize(width: 35, height: 70)
                    )
                    LCARSBar(
                        orientation: .vertical,
                        color: .lcarTan,
                        length: 100,
                        thickness: 35
                    )
                    LCARSEndCap(
                        position: .bottom,
                        color: .lcarTan,
                        size: CGSize(width: 35, height: 70)
                    )
                }
            }
        }
    }
}
