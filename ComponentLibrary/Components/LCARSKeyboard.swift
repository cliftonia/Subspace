//
//  LCARSKeyboard.swift
//  ComponentLibrary
//
//  Created by Clifton Baggerman on 04/10/2025.
//

import SwiftUI

/// LCARS-themed custom keyboard
public struct LCARSKeyboard: View {

    // MARK: - Properties

    @Binding private var text: String
    @State private var isUppercase = false

    // MARK: - Initialization

    public init(text: Binding<String>) {
        self._text = text
    }

    // MARK: - Body

    public var body: some View {
        VStack(spacing: 8) {
            // Header with LCARS code
            HStack {
                Text("LCARS KEYBOARD \(LCARSUtilities.randomDigits(3))")
                    .font(.custom("HelveticaNeue-CondensedBold", size: 14))
                    .foregroundStyle(Color.lcarOrange)

                Spacer()

                Text(isUppercase ? "ABC" : "abc")
                    .font(.custom("HelveticaNeue-CondensedBold", size: 12))
                    .foregroundStyle(Color.lcarWhite.opacity(0.6))
            }
            .padding(.horizontal, 8)

            // Row 1: Q-P
            HStack(spacing: 6) {
                ForEach(["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P"], id: \.self) { letter in
                    LCARSKeyboardKey(
                        label: isUppercase ? letter : letter.lowercased(),
                        color: .lcarOrange
                    ) {
                        appendText(isUppercase ? letter : letter.lowercased())
                    }
                }
            }

            // Row 2: A-L
            HStack(spacing: 6) {
                Spacer().frame(width: 20)
                ForEach(["A", "S", "D", "F", "G", "H", "J", "K", "L"], id: \.self) { letter in
                    LCARSKeyboardKey(
                        label: isUppercase ? letter : letter.lowercased(),
                        color: .lcarViolet
                    ) {
                        appendText(isUppercase ? letter : letter.lowercased())
                    }
                }
                Spacer().frame(width: 20)
            }

            // Row 3: Shift, Z-M, Delete
            HStack(spacing: 6) {
                LCARSKeyboardKey(
                    label: "⇧",
                    width: .wide,
                    color: isUppercase ? .lcarOrange : .lcarTan
                ) {
                    isUppercase.toggle()
                }

                ForEach(["Z", "X", "C", "V", "B", "N", "M"], id: \.self) { letter in
                    LCARSKeyboardKey(
                        label: isUppercase ? letter : letter.lowercased(),
                        color: .lcarPink
                    ) {
                        appendText(isUppercase ? letter : letter.lowercased())
                    }
                }

                LCARSKeyboardKey(
                    label: "⌫",
                    width: .wide,
                    color: .lcarPink
                ) {
                    deleteCharacter()
                }
            }

            // Row 4: Numbers and symbols
            HStack(spacing: 6) {
                ForEach(["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"], id: \.self) { number in
                    LCARSKeyboardKey(
                        label: number,
                        color: .lcarPlum
                    ) {
                        appendText(number)
                    }
                }
            }

            // Row 5: Space and special chars
            HStack(spacing: 6) {
                LCARSKeyboardKey(label: "@", color: .lcarLightOrange) {
                    appendText("@")
                }

                LCARSKeyboardKey(label: ".", color: .lcarLightOrange) {
                    appendText(".")
                }

                LCARSKeyboardKey(
                    label: "Space",
                    width: .extraWide,
                    color: .lcarTan
                ) {
                    appendText(" ")
                }

                LCARSKeyboardKey(label: "-", color: .lcarLightOrange) {
                    appendText("-")
                }

                LCARSKeyboardKey(label: "_", color: .lcarLightOrange) {
                    appendText("_")
                }
            }
        }
        .padding(12)
        .background(Color.lcarBlack)
    }

    // MARK: - Actions

    private func appendText(_ character: String) {
        text += character
    }

    private func deleteCharacter() {
        if !text.isEmpty {
            text.removeLast()
        }
    }
}

// MARK: - Preview

#Preview("LCARS Keyboard") {
    @Previewable @State var text = "Hello World"

    VStack {
        // Text display
        VStack(alignment: .leading, spacing: 8) {
            Text("INPUT")
                .font(.custom("HelveticaNeue-CondensedBold", size: 12))
                .foregroundStyle(Color.lcarOrange)

            Text(text.isEmpty ? "Type something..." : text)
                .font(.custom("HelveticaNeue", size: 18))
                .foregroundStyle(text.isEmpty ? Color.lcarWhite.opacity(0.3) : Color.lcarWhite)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(16)
                .background(Color.white.opacity(0.05))
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .padding(20)

        Spacer()

        // Keyboard
        LCARSKeyboard(text: $text)
    }
    .background(Color.lcarBlack)
}
