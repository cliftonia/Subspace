//
//  LCARSTextField.swift
//  LCARSComponents
//
//  Created by Clifton Baggerman on 04/10/2025.
//

import SwiftUI

/// Native text entry dressed in LCARS, with a coloured end cap marking the field
public struct LCARSTextField: View {

    // MARK: - Properties

    private let placeholder: String
    @Binding private var text: String
    private let isSecure: Bool
    private let color: Color

    // MARK: - Initialization

    public init(placeholder: String, text: Binding<String>, isSecure: Bool = false, color: Color = .lcarOrange) {
        self.placeholder = placeholder
        self._text = text
        self.isSecure = isSecure
        self.color = color
    }

    // MARK: - Body

    public var body: some View {
        HStack(spacing: 10) {
            UnevenRoundedRectangle(topLeadingRadius: 24, bottomLeadingRadius: 24)
                .fill(color)
                .frame(width: 28)
                .accessibilityHidden(true)

            field
                .font(.lcarsBody(19))
                .foregroundStyle(Color.lcarWhite)
                .tint(color)
        }
        .frame(height: 48)
        .overlay(alignment: .bottom) {
            color
                .frame(height: 2)
                .padding(.leading, 38)
                .accessibilityHidden(true)
        }
    }

    // MARK: - Field

    @ViewBuilder private var field: some View {
        let prompt = Text(placeholder).foregroundStyle(color.opacity(0.7))

        if isSecure {
            SecureField(placeholder, text: $text, prompt: prompt)
        } else {
            TextField(placeholder, text: $text, prompt: prompt)
        }
    }
}
