//
//  UsersContentView.swift
//  Subspace
//
//  Created by Clifton Baggerman on 06/10/2025.
//

import LCARSComponents
import SwiftUI

/// Crew list, reflecting the state of the directory
struct UsersContentView: View {
    // MARK: - Properties

    @Bindable var viewModel: UsersViewModel

    // MARK: - Body

    var body: some View {
        ScrollView {
            usersContent
                .padding(.bottom, 16)
        }
        .scrollIndicators(.hidden)
    }

    // MARK: - Content

    @ViewBuilder private var usersContent: some View {
        switch viewModel.state {
        case .idle, .loading:
            statusText("ACCESSING PERSONNEL RECORDS", color: .lcarTan)

        case .loaded:
            loadedState

        case .error(let message):
            statusText(message, color: .lcarRed)
        }
    }

    @ViewBuilder private var loadedState: some View {
        if viewModel.filteredUsers.isEmpty {
            statusText("NO PERSONNEL FOUND", color: .lcarViolet)
        } else {
            LazyVStack(spacing: LCARSMetrics.gutter) {
                ForEach(viewModel.filteredUsers) { user in
                    NavigationLink(value: AppRoute.profile(userId: user.id)) {
                        UserRow(user: user)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private func statusText(_ text: String, color: Color) -> some View {
        Text(text.uppercased())
            .font(.lcars(22))
            .foregroundStyle(color)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 16)
    }
}

// MARK: - Supporting Views

struct UserRow: View {
    let user: User

    var body: some View {
        HStack(spacing: 10) {
            Text(user.initials.uppercased())
                .font(.lcars(22))
                .foregroundStyle(Color.lcarBlack)
                .dynamicTypeSize(...LCARSMetrics.chromeTypeLimit)
                .frame(width: 58, height: 52, alignment: .bottomTrailing)
                .padding(.trailing, 6)
                .background(UnevenRoundedRectangle(topLeadingRadius: 26, bottomLeadingRadius: 26).fill(Color.lcarTan))

            VStack(alignment: .leading, spacing: 0) {
                Text(user.displayName.uppercased())
                    .font(.lcars(22))
                    .foregroundStyle(Color.lcarOrange)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)

                Text(user.email)
                    .font(.lcarsBody(14))
                    .foregroundStyle(Color.lcarWhite.opacity(0.7))
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .contentShape(Rectangle())
        .accessibilityElement(children: .combine)
    }
}
