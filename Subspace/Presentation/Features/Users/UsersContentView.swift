//
//  UsersContentView.swift
//  Subspace
//
//  Created by Clifton Baggerman on 06/10/2025.
//

import LCARSComponents
import SwiftUI

/// Users list content view
struct UsersContentView: View {
    // MARK: - Properties

    @Bindable var viewModel: UsersViewModel

    // MARK: - Body

    var body: some View {
        ScrollView {
            usersContent
        }
        .frame(width: 280, height: 380)
    }

    // MARK: - Content

    @ViewBuilder
    private var usersContent: some View {
        switch viewModel.state {
        case .idle, .loading:
            loadingState

        case .loaded:
            loadedState

        case .error(let message):
            errorState(message: message)
        }
    }

    private var loadingState: some View {
        VStack(spacing: 8) {
            ForEach(0..<5, id: \.self) { _ in
                UserSkeletonRow()
            }
        }
    }

    @ViewBuilder
    private var loadedState: some View {
        if viewModel.filteredUsers.isEmpty {
            emptyState
        } else {
            LazyVStack(spacing: 8) {
                ForEach(viewModel.filteredUsers.prefix(15)) { user in
                    NavigationLink(value: AppRoute.profile(userId: user.id)) {
                        UserRow(user: user)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "person.2.slash.fill")
                .font(.system(size: 40))
                .foregroundStyle(Color.lcarViolet)

            Text("NO USERS")
                .font(.custom("HelveticaNeue-CondensedBold", size: 14))
                .foregroundStyle(Color.lcarOrange)
        }
        .frame(maxWidth: .infinity)
        .padding(40)
    }

    private func errorState(message: String) -> some View {
        VStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 30))
                .foregroundStyle(Color.lcarPlum)

            Text("ERROR")
                .font(.custom("HelveticaNeue-CondensedBold", size: 14))
                .foregroundStyle(Color.lcarPlum)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Supporting Views

struct UserRow: View {
    let user: User

    var body: some View {
        HStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(Color.lcarViolet.opacity(0.3))
                    .frame(width: 24, height: 24)

                Text(user.name.prefix(1).uppercased())
                    .font(.custom("HelveticaNeue-CondensedBold", size: 12))
                    .foregroundStyle(Color.lcarViolet)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(user.name.uppercased())
                    .font(.custom("HelveticaNeue-CondensedBold", size: 11))
                    .foregroundStyle(Color.lcarWhite)
                    .lineLimit(1)

                Text(user.email)
                    .font(.custom("HelveticaNeue", size: 9))
                    .foregroundStyle(Color.lcarWhite.opacity(0.6))
                    .lineLimit(1)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 10))
                .foregroundStyle(Color.lcarTan)
        }
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder(Color.lcarViolet, lineWidth: 1)
        )
    }
}

struct UserSkeletonRow: View {
    var body: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(Color.lcarWhite.opacity(0.2))
                .frame(width: 24, height: 24)

            VStack(alignment: .leading, spacing: 4) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.lcarWhite.opacity(0.2))
                    .frame(width: 100, height: 11)

                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.lcarWhite.opacity(0.1))
                    .frame(width: 140, height: 9)
            }

            Spacer()
        }
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder(Color.lcarWhite.opacity(0.2), lineWidth: 1)
        )
    }
}
