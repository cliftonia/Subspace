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

    // MARK: - Initialization

    public init(placeholder: String, text: Binding<String>) {
        self.placeholder = placeholder
        self._text = text
    }

    // MARK: - Body

    public var body: some View {
        VStack(spacing: 0) {
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

            // Keyboard
            if showKeyboard {
                LCARSKeyboard(text: $text)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .padding(.top, 8)
            }
        }
    }
}

// MARK: - Preview

#Preview("LCARS Text Field") {
    @Previewable @State var email = ""
    @Previewable @State var password = ""

    ZStack {
        Color.lcarBlack
            .ignoresSafeArea()

        VStack(spacing: 20) {
            Text("LCARS TEXT INPUT")
                .font(.custom("HelveticaNeue-CondensedBold", size: 24))
                .foregroundStyle(Color.lcarOrange)

            LCARSTextField(placeholder: "Enter email...", text: $email)

            LCARSTextField(placeholder: "Enter password...", text: $password)

            Spacer()
        }
        .padding(20)
    }
}
