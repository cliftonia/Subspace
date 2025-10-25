//
//  KeyboardShowcaseView.swift
//  ComponentLibrary
//
//  Created by Clifton Baggerman on 04/10/2025.
//

import SwiftUI
import LCARSComponents

/// Showcase view for LCARS keyboard
struct KeyboardShowcaseView: View {
    @Binding var keyboardText: String

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            ShowcaseSection(title: "Input Display") {
                VStack(alignment: .leading, spacing: 8) {
                    Text("OUTPUT")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundStyle(Color.lcarOrange)

                    Text(keyboardText.isEmpty ? "Type something..." : keyboardText)
                        .font(.system(size: 16))
                        .foregroundStyle(keyboardText.isEmpty ? Color.lcarWhite.opacity(0.3) : Color.lcarWhite)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(12)
                        .background(Color.white.opacity(0.05))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }

            ShowcaseSection(title: "Keyboard") {
                LCARSKeyboard(text: $keyboardText)
            }
        }
    }
}
