//
//  KeyboardShowcaseView.swift
//  ComponentLibrary
//
//  Created by Clifton Baggerman on 04/10/2025.
//

import LCARSComponents
import SwiftUI

/// Showcase view for LCARS keyboard
struct KeyboardShowcaseView: View {
    @Binding var keyboardText: String

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            ShowcaseSection(title: "Output") {
                Text(keyboardText.isEmpty ? "TYPE SOMETHING" : keyboardText)
                    .font(.lcarsBody(19))
                    .foregroundStyle(keyboardText.isEmpty ? Color.lcarOrange.opacity(0.6) : Color.lcarWhite)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            ShowcaseSection(title: "Keyboard") {
                LCARSKeyboard(text: $keyboardText)
            }
        }
    }
}
