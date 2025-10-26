//
//  LCARSTextField.swift
//  ComponentLibrary
//
//  Created by Clifton Baggerman on 04/10/2025.
//

import SwiftUI

/// LCARS-styled text field with custom keyboard
public struct LCARSTextField: View {

    // MARK: - Properties

    private let placeholder: String
    @Binding private var text: String
    @FocusState private var isFocused: Bool
    @State private var showKeyboard = false
    private let onSend: (() -> Void)?
    private let onCancel: (() -> Void)?
    private let canSend: Bool

    // MARK: - Initialization

    public init(
        placeholder: String,
        text: Binding<String>,
        onSend: (() -> Void)? = nil,
        onCancel: (() -> Void)? = nil,
        canSend: Bool = true
    ) {
        self.placeholder = placeholder
        self._text = text
        self.onSend = onSend
        self.onCancel = onCancel
        self.canSend = canSend
    }

    // MARK: - Body

    public var body: some View {
        ZStack(alignment: .bottom) {
            // Text field
            HStack(spacing: 12) {
                Text(text.isEmpty ? placeholder : text)
                    .font(.system(size: 16))
                    .foregroundStyle(text.isEmpty ? Color.lcarWhite.opacity(0.3) : Color.lcarWhite)
                    .frame(maxWidth: .infinity, alignment: .leading)

                if !text.isEmpty {
                    Button {
                        text = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(Color.lcarOrange)
                    }
                }
            }
            .padding(16)
            .background(Color.white.opacity(0.05))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay {
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(showKeyboard ? Color.lcarOrange : Color.white.opacity(0.1), lineWidth: 2)
            }
            .onTapGesture {
                withAnimation(.spring(response: 0.3)) {
                    showKeyboard.toggle()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)

            // Keyboard - positioned at bottom
            if showKeyboard {
                LCARSKeyboard(
                    text: $text,
                    onSend: onSend,
                    onCancel: onCancel,
                    canSend: canSend
                )
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
    }
}

// MARK: - Preview
// Note: Preview removed due to iOS 16 compatibility (uses iOS 17+ @Previewable)
