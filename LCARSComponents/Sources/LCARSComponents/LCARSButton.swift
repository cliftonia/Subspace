//
//  LCARSButton.swift
//  ComponentLibrary
//
//  Created by Clifton Baggerman on 04/10/2025.
//

import SwiftUI

/// LCARS-style button with iOS 17+ sensory feedback and sound effects
public struct LCARSButton: View {

    // MARK: - Properties

    private let action: () -> Void
    private let color: Color
    private let width: CGFloat
    private let height: CGFloat
    private let cornerRadius: CGFloat
    private let label: String?
    private let enableHaptics: Bool
    private let enableSound: Bool

    @State private var isPressed = false

    // MARK: - Initialization

    public init(
        action: @escaping () -> Void,
        color: Color,
        width: CGFloat = 125,
        height: CGFloat = 50,
        cornerRadius: CGFloat = 20,
        label: String? = nil,
        enableHaptics: Bool = true,
        enableSound: Bool = false
    ) {
        self.action = action
        self.color = color
        self.width = width
        self.height = height
        self.cornerRadius = cornerRadius
        self.label = label
        self.enableHaptics = enableHaptics
        self.enableSound = enableSound
    }

    // MARK: - Body

    public var body: some View {
        Button {
            action()
        } label: {
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(color)
                .frame(width: width, height: height)
                .overlay(alignment: .bottomTrailing) {
                    if let label = label {
                        HStack {
                            Spacer()
                            Text(label)
                                .font(.custom("HelveticaNeue-CondensedBold", size: 17))
                                .foregroundStyle(Color.lcarBlack)
                        }
                        .scaleEffect(x: 0.7, anchor: .trailing)
                        .padding(.bottom, 5)
                        .padding(.trailing, 20)
                    }
                }
                .scaleEffect(isPressed ? 0.95 : 1.0)
                .brightness(isPressed ? -0.1 : 0)
                .animation(.easeInOut(duration: 0.1), value: isPressed)
        }
        .buttonStyle(.plain)
        .sensoryFeedback(.impact(flexibility: .soft, intensity: 0.7), trigger: isPressed) { oldValue, newValue in
            enableHaptics && newValue
        }
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in isPressed = false }
        )
    }
}

// MARK: - Preview

#Preview("LCARS Buttons") {
    ZStack {
        Color.lcarBlack
            .ignoresSafeArea()

        VStack(spacing: 20) {
            LCARSButton(
                action: {},
                color: .lcarOrange,
                label: LCARSUtilities.randomDigits(7)
            )

            LCARSButton(
                action: {},
                color: .lcarViolet,
                label: LCARSUtilities.randomDigits(7)
            )

            LCARSButton(
                action: {},
                color: .lcarTan,
                label: LCARSUtilities.randomDigits(7)
            )

            LCARSButton(
                action: {},
                color: .lcarPink,
                width: 200,
                height: 60,
                cornerRadius: 30
            )
        }
    }
}
