//
//  ProfileContentView.swift
//  Subspace
//
//  Created by Clifton Baggerman on 06/10/2025.
//

import LCARSComponents
import SwiftUI

/// Profile content display view
struct ProfileContentView: View {
    // MARK: - Properties

    let user: User

    // MARK: - Body

    var body: some View {
        VStack(spacing: 16) {
            avatarSection

            nameSection

            detailsSection

            actionsSection
        }
        .frame(width: 280)
    }

    // MARK: - Sections

    private var avatarSection: some View {
        ZStack {
            Circle()
                .fill(Color.lcarTan.opacity(0.3))
                .frame(width: 80, height: 80)

            Text(user.initials)
                .font(.custom("HelveticaNeue-CondensedBold", size: 32))
                .foregroundStyle(Color.lcarTan)
        }
        .overlay(
            Circle()
                .strokeBorder(Color.lcarTan, lineWidth: 2)
        )
    }

    private var nameSection: some View {
        Text(user.displayName.uppercased())
            .font(.custom("HelveticaNeue-CondensedBold", size: 20))
            .foregroundStyle(Color.lcarOrange)
    }

    private var detailsSection: some View {
        VStack(spacing: 8) {
            ProfileDetailRow(label: "ID", value: user.id, color: .lcarOrange)
            ProfileDetailRow(label: "EMAIL", value: user.email, color: .lcarViolet)
            ProfileDetailRow(
                label: "REGISTERED",
                value: formatDate(user.createdAt),
                color: .lcarTan
            )
        }
    }

    private var actionsSection: some View {
        HStack(spacing: 12) {
            ProfileActionButton(title: "MSG", color: .lcarOrange)
            ProfileActionButton(title: "ACT", color: .lcarViolet)
        }
        .padding(.top, 8)
    }

    // MARK: - Helpers

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}

// MARK: - Supporting Views

struct ProfileDetailRow: View {
    let label: String
    let value: String
    let color: Color

    var body: some View {
        HStack(spacing: 8) {
            Text(label)
                .font(.custom("HelveticaNeue-CondensedBold", size: 10))
                .foregroundStyle(color)
                .frame(width: 60, alignment: .trailing)

            Text(value)
                .font(.custom("HelveticaNeue", size: 12))
                .foregroundStyle(Color.lcarWhite)
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder(color.opacity(0.5), lineWidth: 1)
        )
    }
}

struct ProfileActionButton: View {
    let title: String
    let color: Color

    var body: some View {
        Button {
            // TODO: Implement action
        } label: {
            Text(title)
                .font(.custom("HelveticaNeue-CondensedBold", size: 14))
                .foregroundStyle(Color.lcarBlack)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(color)
                )
        }
    }
}
