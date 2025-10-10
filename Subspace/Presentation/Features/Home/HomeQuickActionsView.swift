//
//  HomeQuickActionsView.swift
//  Subspace
//
//  Created by Clifton Baggerman on 06/10/2025.
//

import LCARSComponents
import SwiftUI

/// Quick actions grid for home screen
struct HomeQuickActionsView: View {
    // MARK: - Body

    var body: some View {
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

    // MARK: - Components

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
