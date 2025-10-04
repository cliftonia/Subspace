//
//  LCARSElbow.swift
//  ComponentLibrary
//
//  Created by Clifton Baggerman on 04/10/2025.
//

import SwiftUI

/// LCARS elbow - iconic corner element
public struct LCARSElbow: View {

    // MARK: - Properties

    private let position: ElbowPosition
    private let color: Color
    private let size: CGFloat
    private let cornerRadius: CGFloat
    private let label: String?

    // MARK: - Initialization

    public init(
        position: ElbowPosition,
        color: Color = .lcarOrange,
        size: CGFloat = 100,
        cornerRadius: CGFloat = 40,
        label: String? = nil
    ) {
        self.position = position
        self.color = color
        self.size = size
        self.cornerRadius = cornerRadius
        self.label = label
    }

    // MARK: - Body

    public var body: some View {
        ZStack {
            // Base elbow shape
            UnevenRoundedRectangle(
                topLeadingRadius: position.topLeading ? cornerRadius : 0,
                bottomLeadingRadius: position.bottomLeading ? cornerRadius : 0,
                bottomTrailingRadius: position.bottomTrailing ? cornerRadius : 0,
                topTrailingRadius: position.topTrailing ? cornerRadius : 0
            )
            .fill(color)
            .frame(width: size, height: size)

            // Optional label
            if let label = label {
                Text(label)
                    .font(.custom("HelveticaNeue-CondensedBold", size: 14))
                    .foregroundStyle(Color.lcarBlack)
                    .scaleEffect(x: 0.8, anchor: .center)
            }
        }
    }
}

// MARK: - Elbow Position

public enum ElbowPosition {
    case topLeading
    case topTrailing
    case bottomLeading
    case bottomTrailing

    var topLeading: Bool {
        self == .topLeading
    }

    var topTrailing: Bool {
        self == .topTrailing
    }

    var bottomLeading: Bool {
        self == .bottomLeading
    }

    var bottomTrailing: Bool {
        self == .bottomTrailing
    }
}

// MARK: - Preview

#Preview("LCARS Elbows") {
    ZStack {
        Color.lcarBlack
            .ignoresSafeArea()

        VStack(spacing: 20) {
            HStack(spacing: 20) {
                LCARSElbow(
                    position: .topLeading,
                    color: .lcarOrange,
                    label: "01-847"
                )

                LCARSElbow(
                    position: .topTrailing,
                    color: .lcarViolet,
                    label: "02-293"
                )
            }

            HStack(spacing: 20) {
                LCARSElbow(
                    position: .bottomLeading,
                    color: .lcarPink,
                    label: "03-562"
                )

                LCARSElbow(
                    position: .bottomTrailing,
                    color: .lcarTan,
                    label: "04-918"
                )
            }
        }
    }
}
