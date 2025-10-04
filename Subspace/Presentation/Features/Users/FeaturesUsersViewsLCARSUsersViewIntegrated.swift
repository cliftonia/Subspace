//
//  LCARSUsersViewIntegrated.swift
//  Subspace
//
//  Created by Clifton Baggerman on 04/10/2025.
//

import SwiftUI
import os

/// LCARS-themed users view with integrated design
struct LCARSUsersViewIntegrated: View {

    // MARK: - Properties

    @State private var viewModel = UsersViewModel()

    private let logger = Logger.app(category: "LCARSUsersViewIntegrated")

    // MARK: - Body

    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color.lcarBlack
                    .ignoresSafeArea()

                VStack(spacing: 10) {
                    // Top frame
                    topFrame
                        .frame(height: max(geo.size.height / 3, 100))

                    // Bottom frame
                    bottomFrame
                        .frame(height: max(geo.size.height * 0.67 - 10, 100))
                }

                // User list content
                userListContent
                    .offset(x: 50, y: 60)
            }
        }
        .ignoresSafeArea()
        .task {
            await viewModel.loadUsers()
        }
        .onAppear {
            logger.logUserAction("Viewed LCARS Users")
        }
    }

    // MARK: - Top Frame

    private var topFrame: some View {
        GeometryReader { geo in
            ZStack {
                VStack(spacing: 5) {
                    Color.lcarViolet
                    Color.lcarPlum
                }
                .cornerRadius(70, corners: .bottomLeft)
                .overlay(alignment: .topTrailing) {
                    if geo.size.width > 100 && geo.size.height > 20 {
                        Color.lcarBlack
                            .cornerRadius(35, corners: .bottomLeft)
                            .frame(width: geo.size.width - 100, height: geo.size.height - 20)
                    }
                }
                .overlay(alignment: .topLeading) {
                    Color.lcarBlack
                        .frame(width: 100, height: 50)
                }
                .overlay(alignment: .bottomTrailing) {
                    ZStack {
                        Color.lcarBlack
                        HStack(spacing: 5) {
                            Color.lcarOrange
                                .frame(width: 20)
                                .padding(.leading, 5)
                            Color.lcarTan
                                .frame(width: 50)
                            Color.lcarViolet
                            Color.lcarPink
                                .frame(width: 20)
                        }
                    }
                    .frame(width: 200, height: 20)
                }
                .overlay(alignment: .leading) {
                    VStack(alignment: .trailing, spacing: 15) {
                        Text("LCARS \(randomDigits(5))")
                        Text("USR-\(randomDigits(6))")
                    }
                    .font(.custom("HelveticaNeue-CondensedBold", size: 17))
                    .foregroundStyle(Color.lcarBlack)
                    .scaleEffect(x: 0.7, anchor: .trailing)
                    .frame(width: 90)
                }
                .overlay(alignment: .topTrailing) {
                    Text("PERSONNEL")
                        .font(.custom("HelveticaNeue-CondensedBold", size: 35))
                        .padding(.top, 45)
                        .foregroundStyle(Color.lcarOrange)
                        .scaleEffect(x: 0.7, anchor: .trailing)
                }
                .overlay(alignment: .trailing) {
                    userStatsGrid
                        .padding(.top, 40)
                }
            }
        }
    }

    private var userStatsGrid: some View {
        Grid(alignment: .trailing) {
            ForEach(0..<7) { row in
                GridRow {
                    ForEach(0..<5) { _ in
                        Text(randomDigits(Int.random(in: 1...6)))
                            .foregroundStyle((row == 1 || row == 4) ? Color.lcarWhite : Color.lcarViolet)
                    }
                }
            }
        }
        .font(.custom("HelveticaNeue-CondensedBold", size: 17))
    }

    // MARK: - Bottom Frame

    private var bottomFrame: some View {
        GeometryReader { geo in
            ZStack {
                VStack(alignment: .leading, spacing: 5) {
                    Color.lcarTan
                        .frame(height: 100)
                        .overlay(alignment: .bottomLeading) {
                            commonLabel(prefix: "ACT")
                                .padding(.bottom, 5)
                        }
                    Color.lcarOrange
                        .frame(height: 200)
                        .overlay(alignment: .bottomLeading) {
                            commonLabel(prefix: "DIR")
                                .padding(.bottom, 5)
                        }
                    Color.lcarPink
                        .frame(height: 50)
                        .overlay(alignment: .leading) {
                            commonLabel(prefix: "ADM")
                        }
                    Color.lcarViolet
                        .overlay(alignment: .topLeading) {
                            commonLabel(prefix: "GRP")
                                .padding(.top, 5)
                        }
                }
                .cornerRadius(70, corners: .topLeft)
                .overlay(alignment: .bottomTrailing) {
                    Color.lcarBlack
                        .cornerRadius(35, corners: .topLeft)
                        .frame(width: geo.size.width - 100, height: geo.size.height - 20)
                }
                .overlay(alignment: .bottomLeading) {
                    Color.lcarBlack
                        .frame(width: 100, height: 50)
                }
                .overlay(alignment: .topTrailing) {
                    ZStack {
                        Color.lcarBlack
                        HStack(alignment: .top, spacing: 5) {
                            Color.lcarPlum
                                .frame(width: 20)
                                .padding(.leading, 5)
                            Color.lcarTan
                                .frame(width: 50, height: 10)
                            Color.lcarOrange
                            Color.lcarViolet
                                .frame(width: 20)
                        }
                    }
                    .frame(width: 200, height: 20)
                }
                .overlay(alignment: .bottomTrailing) {
                    Text("DIRECTORY")
                        .font(.custom("HelveticaNeue-CondensedBold", size: 35))
                        .padding(.bottom, 45)
                        .foregroundStyle(Color.lcarOrange)
                        .scaleEffect(x: 0.7, anchor: .trailing)
                }
            }
        }
    }

    private func commonLabel(prefix: String) -> some View {
        HStack {
            Spacer()
            Text("\(prefix)-\(randomDigits(4))")
                .font(.custom("HelveticaNeue-CondensedBold", size: 17))
                .foregroundStyle(Color.lcarBlack)
        }
        .frame(width: 90)
        .scaleEffect(x: 0.7, anchor: .trailing)
    }

    // MARK: - User List Content

    private var userListContent: some View {
        VStack(spacing: 12) {
            searchBar

            ScrollView {
                usersContent
            }
            .frame(width: 280, height: 380)
        }
    }

    private var searchBar: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 12))
                .foregroundStyle(Color.lcarViolet)

            Text(viewModel.searchText.isEmpty ? "SEARCH" : viewModel.searchText.uppercased())
                .font(.custom("HelveticaNeue-CondensedBold", size: 12))
                .foregroundStyle(viewModel.searchText.isEmpty ? Color.lcarViolet.opacity(0.5) : Color.lcarWhite)
                .frame(maxWidth: .infinity, alignment: .leading)

            if !viewModel.searchText.isEmpty {
                Button {
                    viewModel.clearSearch()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 12))
                        .foregroundStyle(Color.lcarViolet)
                }
            }
        }
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder(Color.lcarViolet, lineWidth: 2)
        )
    }

    @ViewBuilder
    private var usersContent: some View {
        switch viewModel.state {
        case .idle, .loading:
            VStack(spacing: 8) {
                ForEach(0..<5, id: \.self) { _ in
                    userSkeletonRow
                }
            }

        case .loaded:
            if viewModel.filteredUsers.isEmpty {
                emptyState
            } else {
                LazyVStack(spacing: 8) {
                    ForEach(viewModel.filteredUsers.prefix(15)) { user in
                        NavigationLink(value: AppRoute.profile(userId: user.id)) {
                            compactUserRow(user: user)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }

        case .error(let message):
            errorView(message: message)
        }
    }

    private func compactUserRow(user: User) -> some View {
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

    private var userSkeletonRow: some View {
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

    private func errorView(message: String) -> some View {
        VStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 30))
                .foregroundStyle(Color.lcarPlum)

            Text("ERROR")
                .font(.custom("HelveticaNeue-CondensedBold", size: 14))
                .foregroundStyle(Color.lcarPlum)
        }
        .frame(maxWidth: .infinity)
        .padding(40)
    }

    private func randomDigits(_ count: Int) -> String {
        (1...count).map { _ in "\(Int.random(in: 0...9))" }.joined()
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        LCARSUsersViewIntegrated()
    }
}
