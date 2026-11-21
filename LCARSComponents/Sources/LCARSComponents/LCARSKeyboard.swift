//
//  LCARSKeyboard.swift
//  LCARSComponents
//
//  Created by Clifton Baggerman on 04/10/2025.
//

import SwiftUI

/// LCARS-themed keyboard that fills whatever width it is given
public struct LCARSKeyboard: View {

    // MARK: - Key

    private enum Key: Hashable {
        case character(String)
        case shift
        case delete
        case space
    }

    private struct KeyRow {
        let keys: [Key]
        let color: Color
    }

    private static let keySpacing: CGFloat = 3

    private static let rows: [KeyRow] = [
        KeyRow(keys: characters("1234567890"), color: .lcarOrange),
        KeyRow(keys: characters("QWERTYUIOP"), color: .lcarPink),
        KeyRow(keys: characters("ASDFGHJKL"), color: .lcarTan),
        KeyRow(keys: [.shift] + characters("ZXCVBNM") + [.delete], color: .lcarViolet),
        KeyRow(keys: characters("@.,") + [.space] + characters("-?!"), color: .lcarGold)
    ]

    private static func characters(_ text: String) -> [Key] {
        text.map { .character(String($0)) }
    }

    // MARK: - Properties

    @Binding private var text: String
    @State private var isUppercase = true

    // MARK: - Initialization

    public init(text: Binding<String>) {
        self._text = text
    }

    // MARK: - Body

    public var body: some View {
        VStack(spacing: Self.keySpacing) {
            ForEach(Self.rows.indices, id: \.self) { index in
                let row = Self.rows[index]

                LCARSWeightedRow(weights: row.keys.map(weight), spacing: Self.keySpacing) {
                    ForEach(row.keys, id: \.self) { key in
                        keyButton(key, color: row.color)
                    }
                }
                .frame(height: 44)
            }
        }
    }

    // MARK: - Keys

    private func keyButton(_ key: Key, color: Color) -> some View {
        Button {
            press(key)
        } label: {
            Text(label(for: key))
                .font(.lcars(21))
                .foregroundStyle(Color.lcarBlack)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                .dynamicTypeSize(...LCARSMetrics.chromeTypeLimit)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(key == .shift && isUppercase ? Color.lcarWhite : color)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(accessibilityLabel(for: key))
    }

    private func weight(of key: Key) -> CGFloat {
        switch key {
        case .character:
            return 1
        case .shift, .delete:
            return 1.5
        case .space:
            return 4
        }
    }

    private func label(for key: Key) -> String {
        switch key {
        case .character(let character):
            return isUppercase ? character : character.lowercased()
        case .shift:
            return "SHIFT"
        case .delete:
            return "DEL"
        case .space:
            return "SPACE"
        }
    }

    private func accessibilityLabel(for key: Key) -> String {
        switch key {
        case .character:
            return label(for: key)
        case .shift:
            return "Shift"
        case .delete:
            return "Delete"
        case .space:
            return "Space"
        }
    }

    // MARK: - Actions

    private func press(_ key: Key) {
        LCARSAudio.shared.play(.key)

        switch key {
        case .character:
            text += label(for: key)
            isUppercase = false
        case .shift:
            isUppercase.toggle()
        case .delete:
            if !text.isEmpty {
                text.removeLast()
            }
        case .space:
            text += " "
        }
    }
}
