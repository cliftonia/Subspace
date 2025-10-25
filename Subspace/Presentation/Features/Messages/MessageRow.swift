//
//  MessageRow.swift
//  Subspace
//
//  Created by Clifton Baggerman on 06/10/2025.
//

import LCARSComponents
import SwiftUI

/// LCARS-styled message row matching component library design
struct MessageRow: View {
    // MARK: - Properties

    let message: MessageResponse
    let onTap: () -> Void

    @State private var isPressed = false

    // MARK: - Body

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 0) {
                // Left accent bar
                RoundedRectangle(cornerRadius: 8)
                    .fill(messageColor)
                    .frame(width: 6)

                VStack(alignment: .leading, spacing: 8) {
                    // Header row
                    HStack(spacing: 8) {
                        // Status indicator
                        Circle()
                            .fill(message.isRead ? Color.lcarWhite.opacity(0.3) : messageColor)
                            .frame(width: 8, height: 8)

                        // Message type badge
                        Text(message.kind.uppercased())
                            .font(.custom("HelveticaNeue-CondensedBold", size: 10))
                            .foregroundStyle(Color.lcarBlack)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(messageColor)
                            )

                        // Timestamp code
                        Text("T-\(LCARSUtilities.randomDigits(4))")
                            .font(.custom("HelveticaNeue-CondensedBold", size: 10))
                            .foregroundStyle(Color.lcarOrange.opacity(0.6))
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }

                    // Message content
                    Text(message.content)
                        .font(.custom("HelveticaNeue", size: 13))
                        .foregroundStyle(message.isRead ? Color.lcarWhite.opacity(0.6) : Color.lcarWhite)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(12)
            }
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(message.isRead ? Color.clear : messageColor.opacity(0.08))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .strokeBorder(messageColor.opacity(message.isRead ? 0.3 : 0.5), lineWidth: 1)
                    )
            )
            .scaleEffect(isPressed ? 0.98 : 1.0)
            .brightness(isPressed ? -0.05 : 0)
            .animation(.easeInOut(duration: 0.1), value: isPressed)
        }
        .buttonStyle(.plain)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in isPressed = false }
        )
    }

    // MARK: - Helpers

    /// Returns the LCARS color for the current message kind
    private var messageColor: Color {
        switch message.kind.lowercased() {
        case "error": return Color.lcarPlum
        case "warning": return Color.lcarTan
        case "success": return Color.lcarOrange
        default: return Color.lcarViolet
        }
    }
}
