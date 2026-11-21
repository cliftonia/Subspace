//
//  LCARSButton.swift
//  LCARSComponents
//
//  Created by Clifton Baggerman on 04/10/2025.
//

import SwiftUI

/// Flat LCARS button: black condensed lettering seated in the bottom trailing corner of a block of colour
public struct LCARSButtonStyle: ButtonStyle {

    // MARK: - Form

    public enum Form: Sendable {
        /// Fully rounded ends, for actions in the content area
        case pill
        /// Square ends, for buttons stacked in the arm of the frame
        case segment
    }

    // MARK: - Properties

    @Environment(\.isEnabled)
    private var isEnabled

    private let color: Color
    private let form: Form
    private let isSelected: Bool

    // MARK: - Initialization

    public init(color: Color, form: Form = .pill, isSelected: Bool = false) {
        self.color = color
        self.form = form
        self.isSelected = isSelected
    }

    // MARK: - ButtonStyle

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.lcars(20))
            .foregroundStyle(Color.lcarBlack)
            .lineLimit(1)
            .minimumScaleFactor(0.5)
            .dynamicTypeSize(...LCARSMetrics.chromeTypeLimit)
            .accessibilityShowsLargeContentViewer()
            .padding(.trailing, form == .pill ? 18 : 8)
            .padding(.leading, 8)
            .padding(.bottom, 4)
            .frame(maxWidth: .infinity, minHeight: 48, alignment: .bottomTrailing)
            .background(background)
            .brightness(configuration.isPressed ? 0.18 : 0)
            .opacity(isEnabled ? 1 : 0.4)
            .contentShape(Rectangle())
            .accessibilityAddTraits(isSelected ? .isSelected : [])
            .onChange(of: configuration.isPressed) { _, isPressed in
                if isPressed {
                    LCARSAudio.shared.play(.tap)
                }
            }
    }

    // MARK: - Background

    @ViewBuilder private var background: some View {
        switch form {
        case .pill:
            Capsule().fill(fill)
        case .segment:
            Rectangle().fill(fill)
        }
    }

    private var fill: Color {
        isSelected ? Color.lcarWhite : color
    }
}

public extension ButtonStyle where Self == LCARSButtonStyle {
    static func lcars(
        _ color: Color,
        form: LCARSButtonStyle.Form = .pill,
        isSelected: Bool = false
    ) -> LCARSButtonStyle {
        LCARSButtonStyle(color: color, form: form, isSelected: isSelected)
    }
}

// MARK: - Toggle

/// A switch built from the same blocks of colour as the rest of the frame
public struct LCARSToggleStyle: ToggleStyle {

    // MARK: - Properties

    private let color: Color

    // MARK: - Initialization

    public init(color: Color) {
        self.color = color
    }

    // MARK: - ToggleStyle

    public func makeBody(configuration: Configuration) -> some View {
        Button {
            configuration.isOn.toggle()
        } label: {
            HStack(spacing: 8) {
                configuration.label
                    .font(.lcars(21))
                    .foregroundStyle(color)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Text(configuration.isOn ? "ON" : "OFF")
                    .font(.lcars(20))
                    .foregroundStyle(Color.lcarBlack)
                    .dynamicTypeSize(...LCARSMetrics.chromeTypeLimit)
                    .padding(.trailing, 14)
                    .padding(.bottom, 4)
                    .frame(width: 72, height: 44, alignment: .bottomTrailing)
                    .background(Capsule().fill(configuration.isOn ? color : color.opacity(0.35)))
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityValue(configuration.isOn ? "On" : "Off")
    }
}

public extension ToggleStyle where Self == LCARSToggleStyle {
    static func lcars(_ color: Color) -> LCARSToggleStyle {
        LCARSToggleStyle(color: color)
    }
}
