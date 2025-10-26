//
//  LCARSKeyboard.swift
//  ComponentLibrary
//
//  Created by Clifton Baggerman on 04/10/2025.
//

import SwiftUI

/// LCARS-themed custom keyboard with authentic sharp-corner design
public struct LCARSKeyboard: View {

    // MARK: - Properties

    @Binding private var text: String
    @State private var isUppercase = false
    private let onSend: (() -> Void)?
    private let onCancel: (() -> Void)?
    private let canSend: Bool

    // MARK: - Initialization

    public init(
        text: Binding<String>,
        onSend: (() -> Void)? = nil,
        onCancel: (() -> Void)? = nil,
        canSend: Bool = true
    ) {
        self._text = text
        self.onSend = onSend
        self.onCancel = onCancel
        self.canSend = canSend
    }

    // MARK: - Body

    public var body: some View {
        VStack(spacing: 4) {
            // Header with LCARS code
            HStack {
                Text("LCARS INTERFACE \(LCARSUtilities.randomDigits(5))")
                    .font(.custom("HelveticaNeue-CondensedBold", size: 16))
                    .foregroundStyle(Color.lcarOrange)

                Spacer()

                // Mode indicator
                Text(isUppercase ? "UPPERCASE" : "lowercase")
                    .font(.custom("HelveticaNeue-CondensedBold", size: 12))
                    .foregroundStyle(Color.lcarWhite.opacity(0.5))
            }
            .padding(.horizontal, 4)
            .padding(.bottom, 8)

            // Row 1: Numbers
            HStack(spacing: 4) {
                ForEach(["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"], id: \.self) { number in
                    KeyButton(
                        label: number,
                        color: Color(hex: "ED924E"), // Bright Orange
                        pressedColor: Color(hex: "E3722A")
                    ) {
                        appendText(number)
                    }
                }
            }

            // Row 2: Q-P
            HStack(spacing: 4) {
                ForEach(["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P"], id: \.self) { letter in
                    KeyButton(
                        label: isUppercase ? letter : letter.lowercased(),
                        color: Color(hex: "AA7FAA"), // Purple/Pink
                        pressedColor: Color(hex: "906193")
                    ) {
                        appendText(isUppercase ? letter : letter.lowercased())
                        if isUppercase {
                            isUppercase = false
                        }
                    }
                }
            }

            // Row 3: A-L
            HStack(spacing: 4) {
                Spacer().frame(width: 24)
                ForEach(["A", "S", "D", "F", "G", "H", "J", "K", "L"], id: \.self) { letter in
                    KeyButton(
                        label: isUppercase ? letter : letter.lowercased(),
                        color: Color(hex: "D88568"), // Orange/Peach
                        pressedColor: Color(hex: "BE6044")
                    ) {
                        appendText(isUppercase ? letter : letter.lowercased())
                        if isUppercase {
                            isUppercase = false
                        }
                    }
                }
                Spacer().frame(width: 24)
            }

            // Row 4: Shift, Z-M, Backspace
            HStack(spacing: 4) {
                KeyButton(
                    label: "SHIFT",
                    color: isUppercase ? Color(hex: "E6661D") : Color(hex: "C1574C"),
                    pressedColor: isUppercase ? Color(hex: "F5571D") : Color(hex: "A9372E"),
                    width: 60
                ) {
                    isUppercase.toggle()
                }

                ForEach(["Z", "X", "C", "V", "B", "N", "M"], id: \.self) { letter in
                    KeyButton(
                        label: isUppercase ? letter : letter.lowercased(),
                        color: Color(hex: "B5517F"), // Pink
                        pressedColor: Color(hex: "A73769")
                    ) {
                        appendText(isUppercase ? letter : letter.lowercased())
                        if isUppercase {
                            isUppercase = false
                        }
                    }
                }

                KeyButton(
                    label: "⌫",
                    color: Color(hex: "C1574C"), // Dark Red
                    pressedColor: Color(hex: "A9372E"),
                    width: 60
                ) {
                    deleteCharacter()
                }
            }

            // Row 5: Special characters and space
            HStack(spacing: 4) {
                KeyButton(label: "@", color: Color(hex: "ED924E"), pressedColor: Color(hex: "E3722A")) {
                    appendText("@")
                }

                KeyButton(label: ".", color: Color(hex: "ED924E"), pressedColor: Color(hex: "E3722A")) {
                    appendText(".")
                }

                KeyButton(label: ",", color: Color(hex: "ED924E"), pressedColor: Color(hex: "E3722A")) {
                    appendText(",")
                }

                KeyButton(
                    label: "SPACE",
                    color: Color(hex: "AA7FAA"),
                    pressedColor: Color(hex: "906193"),
                    width: 180
                ) {
                    appendText(" ")
                }

                KeyButton(label: "-", color: Color(hex: "ED924E"), pressedColor: Color(hex: "E3722A")) {
                    appendText("-")
                }

                KeyButton(label: "_", color: Color(hex: "ED924E"), pressedColor: Color(hex: "E3722A")) {
                    appendText("_")
                }

                KeyButton(label: "!", color: Color(hex: "ED924E"), pressedColor: Color(hex: "E3722A")) {
                    appendText("!")
                }
            }

            // Row 6: Action buttons (if provided)
            if onSend != nil || onCancel != nil {
                HStack(spacing: 4) {
                    if let onCancel = onCancel {
                        Button {
                            onCancel()
                        } label: {
                            Text("CANCEL")
                                .font(.custom("HelveticaNeue-CondensedBold", size: 18))
                                .foregroundStyle(Color.lcarBlack)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color(hex: "C1574C"))
                                )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }

                    if let onSend = onSend {
                        Button {
                            onSend()
                        } label: {
                            Text("SEND")
                                .font(.custom("HelveticaNeue-CondensedBold", size: 18))
                                .foregroundStyle(Color.lcarBlack)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(canSend ? Color(hex: "ED924E") : Color.white.opacity(0.2))
                                )
                        }
                        .buttonStyle(PlainButtonStyle())
                        .disabled(!canSend)
                    }
                }
            }
        }
        .padding(8)
        .padding(.bottom, 20)
        .background(Color(hex: "222222"))
        .frame(maxWidth: .infinity)
        .ignoresSafeArea(edges: .bottom)
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

// MARK: - Key Button

private struct KeyButton: View {
    let label: String
    let color: Color
    let pressedColor: Color
    let width: CGFloat?
    let action: () -> Void

    @State private var isPressed = false

    init(
        label: String,
        color: Color,
        pressedColor: Color,
        width: CGFloat? = nil,
        action: @escaping () -> Void
    ) {
        self.label = label
        self.color = color
        self.pressedColor = pressedColor
        self.width = width
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.custom("HelveticaNeue-CondensedBold", size: 18))
                .foregroundStyle(Color.black)
                .frame(maxWidth: width == nil ? .infinity : width, maxHeight: .infinity)
                .frame(height: 45)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(isPressed ? pressedColor : color)
                )
        }
        .buttonStyle(PlainButtonStyle())
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in isPressed = false }
        )
    }
}

// MARK: - Preview
// Note: Preview removed due to iOS 16 compatibility (uses iOS 17+ @Previewable)
