//
//  LCARSHomeViewIntegrated.swift
//  Subspace
//
//  Created by Clifton Baggerman on 04/10/2025.
//

import SwiftUI
import os

/// LCARS-themed home screen with integrated design
struct LCARSHomeViewIntegrated: View {

    // MARK: - Properties

    @Environment(AppDependencies.self) private var dependencies
    @Environment(AuthViewModel.self) private var authViewModel
    @State private var viewModel = HomeViewModel()

    private let logger = Logger.app(category: "LCARSHomeViewIntegrated")

    // MARK: - Body

    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color.lcarBlack
                    .ignoresSafeArea()

                VStack(spacing: 10) {
                    // Top frame with content
                    topFrame
                        .frame(height: max(geo.size.height / 3, 100))

                    // Bottom frame with content
                    bottomFrame
                        .frame(height: max(geo.size.height * 0.67 - 10, 100))
                }

                // Centered content area with quick actions
                quickActionsGrid
                    .offset(x: 50, y: 60)
            }
        }
        .ignoresSafeArea()
        .task {
            await viewModel.loadHomeData(
                messageService: dependencies.messageService
            )
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    Task {
                        await authViewModel.logout()
                    }
                } label: {
                    Text("LOGOUT")
                        .font(.custom("HelveticaNeue-CondensedBold", size: 14))
                        .foregroundStyle(Color.lcarOrange)
                }
            }
        }
        .onAppear {
            logger.logUserAction("Viewed LCARS Home Screen")
        }
    }

    // MARK: - Top Frame

    private var topFrame: some View {
        GeometryReader { geo in
            ZStack {
                VStack(spacing: 5) {
                    Color.lcarPink
                    Color.lcarViolet
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
                            Color.lcarPink
                                .frame(width: 50)
                            Color.lcarPink
                            Color.lcarPlum
                                .frame(width: 20)
                        }
                    }
                    .frame(width: 200, height: 20)
                }
                .overlay(alignment: .leading) {
                    VStack(alignment: .trailing, spacing: 15) {
                        Text("LCARS \(LCARSUtilities.randomDigits(5))")
                        Text("02-\(LCARSUtilities.randomDigits(6))")
                    }
                    .font(.custom("HelveticaNeue-CondensedBold", size: 17))
                    .foregroundStyle(Color.lcarBlack)
                    .scaleEffect(x: 0.7, anchor: .trailing)
                    .frame(width: 90)
                }
                .overlay(alignment: .topTrailing) {
                    Text("SUBSPACE \(LCARSUtilities.randomDigits(3))")
                        .font(.custom("HelveticaNeue-CondensedBold", size: 35))
                        .padding(.top, 45)
                        .foregroundStyle(Color.lcarOrange)
                        .scaleEffect(x: 0.7, anchor: .trailing)
                }
                .overlay(alignment: .trailing) {
                    statusGrid
                        .padding(.top, 40)
                }
            }
        }
    }

    private var statusGrid: some View {
        Grid(alignment: .trailing) {
            ForEach(0..<7) { row in
                GridRow {
                    ForEach(0..<5) { _ in
                        Text(LCARSUtilities.randomDigits(Int.random(in: 1...6)))
                            .foregroundStyle((row == 3 || row == 4) ? Color.lcarWhite : Color.lcarOrange)
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
                    Color.lcarPlum
                        .frame(height: 100)
                        .overlay(alignment: .bottomLeading) {
                            commonLabel(prefix: "03")
                                .padding(.bottom, 5)
                        }
                    Color.lcarPlum
                        .frame(height: 200)
                        .overlay(alignment: .bottomLeading) {
                            commonLabel(prefix: "04")
                                .padding(.bottom, 5)
                        }
                    Color.lcarOrange
                        .frame(height: 50)
                        .overlay(alignment: .leading) {
                            commonLabel(prefix: "05")
                        }
                    Color.lcarTan
                        .overlay(alignment: .topLeading) {
                            commonLabel(prefix: "06")
                                .padding(.top, 5)
                        }
                }
                .cornerRadius(70, corners: .topLeft)
                .overlay(alignment: .bottomTrailing) {
                    if geo.size.width > 100 && geo.size.height > 20 {
                        Color.lcarBlack
                            .cornerRadius(35, corners: .topLeft)
                            .frame(width: geo.size.width - 100, height: geo.size.height - 20)
                    }
                }
                .overlay(alignment: .bottomLeading) {
                    Color.lcarBlack
                        .frame(width: 100, height: 50)
                }
                .overlay(alignment: .topTrailing) {
                    ZStack {
                        Color.lcarBlack
                        HStack(alignment: .top, spacing: 5) {
                            Color.lcarLightOrange
                                .frame(width: 20)
                                .padding(.leading, 5)
                            Color.lcarLightOrange
                                .frame(width: 50, height: 10)
                            Color.lcarPink
                            Color.lcarOrange
                                .frame(width: 20)
                        }
                    }
                    .frame(width: 200, height: 20)
                }
                .overlay(alignment: .bottomTrailing) {
                    Text("COMMAND \(LCARSUtilities.randomDigits(3))")
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
            Text("\(prefix)-\(LCARSUtilities.randomDigits(6))")
                .font(.custom("HelveticaNeue-CondensedBold", size: 17))
                .foregroundStyle(Color.lcarBlack)
        }
        .frame(width: 90)
        .scaleEffect(x: 0.7, anchor: .trailing)
    }

    // MARK: - Quick Actions Grid

    private var quickActionsGrid: some View {
        Grid {
            GridRow {
                quickActionButton(
                    title: "DASHBOARD",
                    icon: "chart.line.uptrend.xyaxis",
                    color: Color.lcarViolet,
                    route: .dashboard
                )
                quickActionButton(
                    title: "MESSAGES",
                    icon: "message.fill",
                    color: Color.lcarTan,
                    route: .messages
                )
            }
            GridRow {
                quickActionButton(
                    title: "USERS",
                    icon: "person.2.fill",
                    color: Color.lcarOrange,
                    route: .users
                )
                quickActionButton(
                    title: "SETTINGS",
                    icon: "gear",
                    color: Color.lcarViolet,
                    route: .settings
                )
            }
        }
        .frame(width: 300, height: 250)
    }

    @ViewBuilder
    private func quickActionButton(
        title: String,
        icon: String,
        color: Color,
        route: AppRoute
    ) -> some View {
        NavigationLink(value: route) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 28))
                    .foregroundStyle(Color.lcarBlack)

                Text(title)
                    .font(.custom("HelveticaNeue-CondensedBold", size: 12))
                    .foregroundStyle(Color.lcarBlack)
            }
            .frame(width: 125, height: 100)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(color)
            )
            .overlay(alignment: .bottomTrailing) {
                HStack {
                    Spacer()
                    Text("\(LCARSUtilities.randomDigits(4))-\(LCARSUtilities.randomDigits(3))")
                        .font(.custom("HelveticaNeue-CondensedBold", size: 14))
                        .foregroundStyle(Color.lcarBlack)
                }
                .scaleEffect(x: 0.7, anchor: .trailing)
                .padding(.bottom, 5)
                .padding(.trailing, 15)
            }
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        LCARSHomeViewIntegrated()
            .environment(AppDependencies())
            .environment(AuthViewModel(authService: MockAuthService()))
    }
}
