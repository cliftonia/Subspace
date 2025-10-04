//
//  LCARSKeyboardKey.swift
//  ComponentLibrary
//
//  Created by Clifton Baggerman on 04/10/2025.
//

import SwiftUI

/// LCARS-themed keyboard key with sharp corners (authentic LCARS design)
public struct LCARSKeyboardKey: View {

    // MARK: - Properties

    private let label: String
    private let action: () -> Void
    private let width: KeyWidth
    private let color: Color

    @State private var isPressed = false

    // MARK: - Initialization

    public init(
        label: String,
        width: KeyWidth = .standard,
        color: Color = .lcarOrange,
        action: @escaping () -> Void
    ) {
        self.label = label
        self.width = width
        self.color = color
        self.action = action
    }

    // MARK: - Body

    public var body: some View {
        Button(action: action) {
            Text(label)
                .font(.custom("HelveticaNeue-CondensedBold", size: 18))
                .foregroundStyle(Color.black)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .frame(height: 45)
                .background(isPressed ? color.opacity(0.7) : color)
        }
        .buttonStyle(PlainButtonStyle())
        .frame(width: width.value)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in isPressed = false }
        )
    }
}

// MARK: - Key Width

public enum KeyWidth {
    case standard
    case wide
    case extraWide

    var value: CGFloat? {
        switch self {
        case .standard: return nil
        case .wide: return 60
        case .extraWide: return 120
        }
    }
}

// MARK: - Preview

#Preview("Keyboard Keys") {
    ZStack {
        Color(hex: "222222")
            .ignoresSafeArea()

        VStack(spacing: 12) {
            HStack(spacing: 4) {
                LCARSKeyboardKey(label: "Q", color: Color(hex: "AA7FAA"), action: {})
                LCARSKeyboardKey(label: "W", color: Color(hex: "AA7FAA"), action: {})
                LCARSKeyboardKey(label: "E", color: Color(hex: "AA7FAA"), action: {})
                LCARSKeyboardKey(label: "R", color: Color(hex: "AA7FAA"), action: {})
            }

            HStack(spacing: 4) {
                LCARSKeyboardKey(label: "SPACE", width: .extraWide, color: Color(hex: "D88568"), action: {})
                LCARSKeyboardKey(label: "⌫", width: .wide, color: Color(hex: "C1574C"), action: {})
            }

            HStack(spacing: 4) {
                LCARSKeyboardKey(label: "1", color: Color(hex: "ED924E"), action: {})
                LCARSKeyboardKey(label: "2", color: Color(hex: "ED924E"), action: {})
                LCARSKeyboardKey(label: "3", color: Color(hex: "ED924E"), action: {})
            }
        }
        .padding(20)
    }
}
