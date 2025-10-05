//
//  LCARSComponents.swift
//  Subspace
//
//  Created by Clifton Baggerman on 04/10/2025.
//

import SwiftUI

// MARK: - LCARS Button

struct LCARSButton: View {
    let title: String
    let code: String
    let color: Color
    let action: () -> Void

    init(
        _ title: String,
        code: String = "",
        color: Color = .lcarOrange,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.color = color
        self.action = action
        self.code = code.isEmpty ? String((1...4).map { _ in "\(Int.random(in: 0...9))" }.joined()) : code
    }

    var body: some View {
        Button(action: action) {
            ZStack(alignment: .bottomTrailing) {
                RoundedRectangle(cornerRadius: 20)
                    .fill(color)
                    .frame(height: 50)

                HStack {
                    Spacer()
                    Text(code)
                        .font(.custom("HelveticaNeue-CondensedBold", size: 14))
                        .foregroundStyle(.black)
                        .scaleEffect(x: 0.7, anchor: .trailing)
                }
                .padding(.bottom, 4)
                .padding(.trailing, 12)
            }
            .overlay(alignment: .leading) {
                Text(title)
                    .font(.custom("HelveticaNeue-CondensedBold", size: 18))
                    .foregroundStyle(.black)
                    .padding(.leading, 20)
            }
        }
    }
}

// MARK: - LCARS Panel

struct LCARSPanel: View {
    let color: Color
    let height: CGFloat
    let cornerRadius: CGFloat
    let label: String?

    init(
        color: Color = .lcarOrange,
        height: CGFloat = 100,
        cornerRadius: CGFloat = 20,
        label: String? = nil
    ) {
        self.color = color
        self.height = height
        self.cornerRadius = cornerRadius
        self.label = label
    }

    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(color)
            .frame(height: height)
            .overlay(alignment: .bottomTrailing) {
                if let label = label {
                    Text(label)
                        .font(.custom("HelveticaNeue-CondensedBold", size: 14))
                        .foregroundStyle(.black)
                        .scaleEffect(x: 0.7, anchor: .trailing)
                        .padding(.bottom, 5)
                        .padding(.trailing, 15)
                }
            }
    }
}

// MARK: - LCARS Text Field

struct LCARSTextField: View {
    let placeholder: String
    @Binding var text: String
    let icon: String
    var isSecure: Bool = false
    var showVisibilityToggle: Bool = false
    @Binding var isPasswordVisible: Bool

    init(
        placeholder: String,
        text: Binding<String>,
        icon: String,
        isSecure: Bool = false,
        showVisibilityToggle: Bool = false,
        isPasswordVisible: Binding<Bool> = .constant(false)
    ) {
        self.placeholder = placeholder
        self._text = text
        self.icon = icon
        self.isSecure = isSecure
        self.showVisibilityToggle = showVisibilityToggle
        self._isPasswordVisible = isPasswordVisible
    }

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundStyle(Color.lcarOrange)
                .frame(width: 24)

            ZStack(alignment: .leading) {
                // Placeholder text
                if text.isEmpty {
                    Text(placeholder)
                        .font(.custom("HelveticaNeue-CondensedBold", size: 16))
                        .foregroundStyle(Color.lcarOrange.opacity(0.5))
                }

                // Actual text field
                if isSecure {
                    SecureField("", text: $text)
                        .font(.custom("HelveticaNeue-CondensedBold", size: 16))
                        .foregroundStyle(Color.lcarWhite)
                } else {
                    TextField("", text: $text)
                        .font(.custom("HelveticaNeue-CondensedBold", size: 16))
                        .foregroundStyle(Color.lcarWhite)
                }
            }

            // Password visibility toggle
            if showVisibilityToggle {
                Button(action: { isPasswordVisible.toggle() }) {
                    Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                        .font(.system(size: 16))
                        .foregroundStyle(Color.lcarOrange.opacity(0.7))
                        .frame(width: 24, height: 24)
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .strokeBorder(Color.lcarOrange, lineWidth: 2)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.black.opacity(0.5))
                )
        )
        .tint(Color.lcarOrange) // Cursor color
    }
}

// MARK: - LCARS Header

struct LCARSHeader: View {
    let title: String
    let subtitle: String?
    let code: String

    init(_ title: String, subtitle: String? = nil, code: String = "") {
        self.title = title
        self.subtitle = subtitle
        let digits = (1...5).map { _ in "\(Int.random(in: 0...9))" }.joined()
        self.code = code.isEmpty ? "LCARS \(digits)" : code
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(code)
                .font(.custom("HelveticaNeue-CondensedBold", size: 14))
                .foregroundStyle(Color.lcarOrange)
                .scaleEffect(x: 0.8, anchor: .leading)

            Text(title)
                .font(.custom("HelveticaNeue-CondensedBold", size: 36))
                .foregroundStyle(Color.lcarOrange)
                .scaleEffect(x: 0.8, anchor: .leading)

            if let subtitle = subtitle {
                Text(subtitle)
                    .font(.custom("HelveticaNeue-CondensedBold", size: 16))
                    .foregroundStyle(Color.lcarWhite.opacity(0.7))
            }
        }
    }
}

// MARK: - LCARS Corner Radius Extension

extension View {
    func lcarCornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(LCARSRoundedCorner(radius: radius, corners: corners))
    }
}

struct LCARSRoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

