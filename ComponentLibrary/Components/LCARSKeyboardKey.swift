//
//  LCARSKeyboardKey.swift
//  ComponentLibrary
//
//  Created by Clifton Baggerman on 04/10/2025.
//

import SwiftUI

/// LCARS-themed keyboard key
public struct LCARSKeyboardKey: View {

    // MARK: - Properties

    private let label: String
    private let action: () -> Void
    private let width: KeyWidth
    private let color: Color

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
                .font(.custom("HelveticaNeue-CondensedBold", size: 20))
                .foregroundStyle(Color.lcarBlack)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(color)
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .frame(width: width.value, height: 50)
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
        case .wide: return 80
        case .extraWide: return 120
        }
    }
}

// MARK: - Preview

#Preview("Keyboard Keys") {
    ZStack {
        Color.lcarBlack
            .ignoresSafeArea()

        VStack(spacing: 12) {
            HStack(spacing: 8) {
                LCARSKeyboardKey(label: "Q", action: {})
                LCARSKeyboardKey(label: "W", action: {})
                LCARSKeyboardKey(label: "E", action: {})
                LCARSKeyboardKey(label: "R", action: {})
            }

            HStack(spacing: 8) {
                LCARSKeyboardKey(label: "Space", width: .extraWide, color: .lcarTan, action: {})
                LCARSKeyboardKey(label: "⌫", color: .lcarPink, action: {})
            }
        }
        .padding(20)
    }
}
