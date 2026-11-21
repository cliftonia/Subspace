//
//  MessageRow.swift
//  Subspace
//
//  Created by Clifton Baggerman on 06/10/2025.
//

import LCARSComponents
import SwiftUI

/// A message seated against a colour bar. Tapping opens it and marks it read.
struct MessageRow: View {
    // MARK: - Properties

    let message: MessageResponse
    let onRead: () -> Void
    let onArchive: () -> Void

    @Environment(\.dynamicTypeSize)
    private var dynamicTypeSize
    @State private var isExpanded = false

    // MARK: - Body

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            UnevenRoundedRectangle(topLeadingRadius: 12, bottomLeadingRadius: 12)
                .fill(message.isRead ? messageColor.opacity(0.45) : messageColor)
                .frame(width: 14)
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 4) {
                header

                Text(message.content)
                    .font(.lcarsBody(16))
                    .foregroundStyle(message.isRead ? Color.lcarWhite.opacity(0.65) : Color.lcarWhite)
                    .lineLimit(isExpanded || dynamicTypeSize.isAccessibilitySize ? nil : 2)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)

                if isExpanded && canArchive {
                    Button("Archive", action: onArchive)
                        .buttonStyle(.lcars(messageColor))
                        .padding(.top, 4)
                }
            }
            .padding(.vertical, 4)
        }
        .contentShape(Rectangle())
        .onTapGesture(perform: toggle)
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(.isButton)
        .accessibilityHint(isExpanded ? "Collapses the message" : "Opens the message and marks it read")
    }

    // MARK: - Header

    private var header: some View {
        HStack(spacing: 8) {
            Text(message.kind.uppercased())
                .font(.lcars(17))
                .foregroundStyle(messageColor)
                .lineLimit(1)
                .fixedSize()

            Text(message.isRead ? "" : "UNREAD")
                .font(.lcars(15))
                .foregroundStyle(Color.lcarWhite)
                .lineLimit(1)
                .fixedSize()

            Text(LCARSUtilities.stableDigits(message.id, count: 6))
                .font(.lcars(15))
                .foregroundStyle(Color.lcarOrange.opacity(0.7))
                .lineLimit(1)
                .opacity(dynamicTypeSize.isAccessibilitySize ? 0 : 1)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .accessibilityHidden(true)
        }
    }

    // MARK: - Helpers

    /// The real backend has no archive route, so only the local fleet offers it
    private var canArchive: Bool {
        AppConfiguration.usesLocalFleet && message.isArchived != true
    }

    private func toggle() {
        withAnimation(.easeInOut(duration: 0.15)) {
            isExpanded.toggle()
        }
        if !message.isRead {
            onRead()
        }
    }

    /// Returns the LCARS color for the current message kind
    private var messageColor: Color {
        switch message.kind.lowercased() {
        case "error":
            return .lcarRed
        case "warning":
            return .lcarTan
        case "success":
            return .lcarGold
        default:
            return .lcarViolet
        }
    }
}
