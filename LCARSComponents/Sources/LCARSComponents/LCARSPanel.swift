//
//  LCARSPanel.swift
//  ComponentLibrary
//
//  Created by Clifton Baggerman on 04/10/2025.
//

import SwiftUI

/// LCARS-style colored panel with customizable height and corner radius
public struct LCARSPanel: View {

    // MARK: - Properties

    private let color: Color
    private let height: CGFloat
    private let cornerRadius: CGFloat
    private let label: String?

    // MARK: - Initialization

    public init(
        color: Color,
        height: CGFloat = 100,
        cornerRadius: CGFloat = 40,
        label: String? = nil
    ) {
        self.color = color
        self.height = height
        self.cornerRadius = cornerRadius
        self.label = label
    }

    // MARK: - Body

    public var body: some View {
        color
            .frame(height: height)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .overlay(alignment: .leading) {
                if let label = label {
                    HStack {
                        Spacer()
                        Text(label)
                            .font(.custom("HelveticaNeue-CondensedBold", size: 17))
                            .foregroundStyle(Color.lcarBlack)
                    }
                    .frame(width: 90)
                    .scaleEffect(x: 0.7, anchor: .trailing)
                    .padding(.leading, 10)
                }
            }
    }
}

// MARK: - Preview

#Preview("LCARS Panels") {
    ZStack {
        Color.lcarBlack
            .ignoresSafeArea()

        VStack(spacing: 8) {
            LCARSPanel(
                color: .lcarOrange,
                height: 100,
                label: LCARSUtilities.systemCode(section: "01")
            )

            LCARSPanel(
                color: .lcarPink,
                height: 80,
                label: LCARSUtilities.systemCode(section: "02")
            )

            LCARSPanel(
                color: .lcarViolet,
                height: 120,
                label: LCARSUtilities.systemCode(section: "03")
            )

            LCARSPanel(
                color: .lcarPlum,
                height: 60
            )

            LCARSPanel(
                color: .lcarTan,
                height: 90,
                cornerRadius: 20
            )
        }
        .padding(20)
    }
}
