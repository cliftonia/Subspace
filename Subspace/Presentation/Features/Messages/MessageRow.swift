//
//  MessageRow.swift
//  Subspace
//
//  Created by Clifton Baggerman on 06/10/2025.
//

import LCARSComponents
import SwiftUI

/// LCARS-styled message row
struct MessageRow: View {
    // MARK: - Properties

    let message: MessageResponse
    let onTap: () -> Void

    // MARK: - Body

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 0) {
                // Left accent bar
                RoundedRectangle(cornerRadius: 8)
                    .fill(messageColor(message.kind))
                    .frame(width: 8)

                VStack(alignment: .leading, spacing: 6) {
                    // Header row
                    HStack {
                        // Status indicator
                        Circle()
                            .fill(message.isRead ? Color.lcarWhite.opacity(0.3) : Color.lcarOrange)
                            .frame(width: 8, height: 8)

                        // Message type badge
                        Text(message.kind.capitalized.uppercased())
                            .font(.custom("HelveticaNeue-CondensedBold", size: 10))
                            .foregroundStyle(Color.lcarBlack)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(messageColor(message.kind))
                            )

                        Spacer()

                        // Timestamp code
                        Text("T-\(LCARSUtilities.randomDigits(4))")
                            .font(.custom("HelveticaNeue-CondensedBold", size: 10))
                            .foregroundStyle(Color.lcarOrange.opacity(0.6))
                    }

                    // Message content
                    Text(message.content)
                        .font(.custom("HelveticaNeue", size: 13))
                        .foregroundStyle(message.isRead ? Color.lcarWhite.opacity(0.6) : Color.lcarWhite)
                        .lineLimit(2)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(12)
            }
            .frame(height: 70)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(message.isRead ? Color.clear : messageColor(message.kind).opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .strokeBorder(messageColor(message.kind).opacity(0.5), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(.plain)
    }

    // MARK: - Helpers

    /// Returns the LCARS color for a given message kind
    private func messageColor(_ kind: String) -> Color {
        switch kind.lowercased() {
        case "error": return Color.lcarPlum
        case "warning": return Color.lcarTan
        case "success": return Color.lcarOrange
        default: return Color.lcarViolet
        }
    }
}
