//
//  LCARSProfileViewIntegrated.swift
//  Subspace
//
//  Created by Clifton Baggerman on 04/10/2025.
//

import SwiftUI
import os

/// LCARS-themed profile view with integrated design
struct LCARSProfileViewIntegrated: View {

    // MARK: - Properties

    let userId: String

    @Environment(AppDependencies.self) private var dependencies
    @State private var viewModel = ProfileViewModel()

    private let logger = Logger.app(category: "LCARSProfileViewIntegrated")

    // MARK: - Body

    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color.lcarBlack
                    .ignoresSafeArea()

                VStack(spacing: 10) {
                    // Top frame
                    topFrame
                        .frame(height: geo.size.height / 3)

                    // Bottom frame
                    bottomFrame
                        .frame(height: geo.size.height * (2/3) - 10)
                }

                // Profile content
                profileContent
                    .offset(x: 50, y: 60)
            }
        }
        .ignoresSafeArea()
        .task {
            await viewModel.loadProfile(
                userId: userId,
                userService: dependencies.userService
            )
        }
        .onAppear {
            logger.logUserAction("Viewed LCARS Profile", context: userId)
        }
    }

    // MARK: - Top Frame

    private var topFrame: some View {
        GeometryReader { geo in
            ZStack {
                VStack(spacing: 5) {
                    Color.lcarTan
                    Color.lcarLightOrange
                }
                .cornerRadius(70, corners: .bottomLeft)
                .overlay(alignment: .topTrailing) {
                    Color.lcarBlack
                        .cornerRadius(35, corners: .bottomLeft)
                        .frame(width: geo.size.width - 100, height: geo.size.height - 20)
                }
                .overlay(alignment: .topLeading) {
                    Color.lcarBlack
                        .frame(width: 100, height: 50)
                }
                .overlay(alignment: .bottomTrailing) {
                    ZStack {
                        Color.lcarBlack
                        HStack(spacing: 5) {
                            Color.lcarViolet
                                .frame(width: 20)
                                .padding(.leading, 5)
                            Color.lcarOrange
                                .frame(width: 50)
                            Color.lcarTan
                            Color.lcarPink
                                .frame(width: 20)
                        }
                    }
                    .frame(width: 200, height: 20)
                }
                .overlay(alignment: .leading) {
                    VStack(alignment: .trailing, spacing: 15) {
                        Text("LCARS \(LCARSUtilities.randomDigits(5))")
                        Text("PFL-\(LCARSUtilities.randomDigits(6))")
                    }
                    .font(.custom("HelveticaNeue-CondensedBold", size: 17))
                    .foregroundStyle(Color.lcarBlack)
                    .scaleEffect(x: 0.7, anchor: .trailing)
                    .frame(width: 90)
                }
                .overlay(alignment: .topTrailing) {
                    Text("PERSONNEL FILE")
                        .font(.custom("HelveticaNeue-CondensedBold", size: 32))
                        .padding(.top, 45)
                        .foregroundStyle(Color.lcarOrange)
                        .scaleEffect(x: 0.7, anchor: .trailing)
                }
                .overlay(alignment: .trailing) {
                    profileStatsGrid
                        .padding(.top, 40)
                }
            }
        }
    }

    private var profileStatsGrid: some View {
        Grid(alignment: .trailing) {
            ForEach(0..<7) { row in
                GridRow {
                    ForEach(0..<5) { _ in
                        Text(LCARSUtilities.randomDigits(Int.random(in: 1...6)))
                            .foregroundStyle((row == 0 || row == 6) ? Color.lcarWhite : Color.lcarTan)
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
                    Color.lcarOrange
                        .frame(height: 100)
                        .overlay(alignment: .bottomLeading) {
                            LCARSUtilities.commonLabel(prefix: "BIO")
                                .padding(.bottom, 5)
                        }
                    Color.lcarViolet
                        .frame(height: 200)
                        .overlay(alignment: .bottomLeading) {
                            LCARSUtilities.commonLabel(prefix: "SEC")
                                .padding(.bottom, 5)
                        }
                    Color.lcarPink
                        .frame(height: 50)
                        .overlay(alignment: .leading) {
                            LCARSUtilities.commonLabel(prefix: "LOG")
                        }
                    Color.lcarPlum
                        .overlay(alignment: .topLeading) {
                            LCARSUtilities.commonLabel(prefix: "ACT")
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
                            Color.lcarTan
                                .frame(width: 20)
                                .padding(.leading, 5)
                            Color.lcarOrange
                                .frame(width: 50, height: 10)
                            Color.lcarViolet
                            Color.lcarPink
                                .frame(width: 20)
                        }
                    }
                    .frame(width: 200, height: 20)
                }
                .overlay(alignment: .bottomTrailing) {
                    Text("RECORD \(LCARSUtilities.randomDigits(3))")
                        .font(.custom("HelveticaNeue-CondensedBold", size: 35))
                        .padding(.bottom, 45)
                        .foregroundStyle(Color.lcarOrange)
                        .scaleEffect(x: 0.7, anchor: .trailing)
                }
            }
        }
    }

    // MARK: - Profile Content

    @ViewBuilder
    private var profileContent: some View {
        switch viewModel.state {
        case .idle, .loading:
            loadingContent

        case .loaded(let user):
            loadedContent(user: user)

        case .error(let message):
            errorContent(message: message)
        }
    }

    private var loadingContent: some View {
        VStack(spacing: 16) {
            Circle()
                .fill(Color.lcarWhite.opacity(0.2))
                .frame(width: 80, height: 80)

            RoundedRectangle(cornerRadius: 4)
                .fill(Color.lcarWhite.opacity(0.2))
                .frame(width: 150, height: 20)

            VStack(spacing: 8) {
                ForEach(0..<3, id: \.self) { _ in
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.lcarWhite.opacity(0.1))
                        .frame(width: 250, height: 40)
                }
            }
        }
    }

    private func loadedContent(user: User) -> some View {
        VStack(spacing: 16) {
            // Avatar
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

            // Name
            Text(user.displayName.uppercased())
                .font(.custom("HelveticaNeue-CondensedBold", size: 20))
                .foregroundStyle(Color.lcarOrange)

            // Details
            VStack(spacing: 8) {
                detailRow(label: "ID", value: user.id, color: Color.lcarOrange)
                detailRow(label: "EMAIL", value: user.email, color: Color.lcarViolet)
                detailRow(
                    label: "REGISTERED",
                    value: formatDate(user.createdAt),
                    color: Color.lcarTan
                )
            }

            // Actions
            HStack(spacing: 12) {
                actionButton(title: "MSG", color: Color.lcarOrange)
                actionButton(title: "ACT", color: Color.lcarViolet)
            }
            .padding(.top, 8)
        }
        .frame(width: 280)
    }

    private func detailRow(label: String, value: String, color: Color) -> some View {
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

    private func actionButton(title: String, color: Color) -> some View {
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

    private func errorContent(message: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 40))
                .foregroundStyle(Color.lcarPlum)

            Text("ERROR")
                .font(.custom("HelveticaNeue-CondensedBold", size: 16))
                .foregroundStyle(Color.lcarPlum)

            Text(message)
                .font(.custom("HelveticaNeue", size: 12))
                .foregroundStyle(Color.lcarWhite.opacity(0.7))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
        }
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        LCARSProfileViewIntegrated(userId: "user-1")
            .environment(AppDependencies())
    }
}
