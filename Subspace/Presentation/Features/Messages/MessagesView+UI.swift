//
//  MessagesView+UI.swift
//  Subspace
//
//  Created by Clifton Baggerman on 25/10/2025.
//

import LCARSComponents
import SwiftUI

// MARK: - UI Components

extension MessagesView {
    // MARK: - Top Frame

    var topFrame: some View {
        GeometryReader { geo in
            ZStack {
                VStack(spacing: 5) {
                    selectedFilter.color
                    Color.lcarPink
                    Color.lcarViolet
                }
                .clipShape(RoundedRectangle(cornerRadius: 70))
                .overlay(alignment: .topTrailing) {
                    Color.lcarBlack
                        .clipShape(RoundedRectangle(cornerRadius: 35))
                        .frame(width: geo.size.width - 100, height: geo.size.height - 20)
                }
                .overlay(alignment: .topLeading) {
                    Color.lcarBlack
                        .frame(width: 100, height: 50)
                }
                .overlay(alignment: .topTrailing) {
                    Text(selectedFilter.headerTitle)
                        .font(.custom("HelveticaNeue-CondensedBold", size: 32))
                        .padding(.top, 50)
                        .padding(.trailing, 20)
                        .foregroundStyle(selectedFilter.color)
                        .scaleEffect(x: 0.7, anchor: .trailing)
                }
                .overlay(alignment: .leading) {
                    VStack(alignment: .trailing, spacing: 10) {
                        Text("LCARS \(LCARSUtilities.randomDigits(5))")
                        Text(String(format: "%02d", selectedFilter.rawValue) + "-\(LCARSUtilities.randomDigits(6))")
                    }
                    .font(.custom("HelveticaNeue-CondensedBold", size: 17))
                    .foregroundStyle(Color.lcarBlack)
                    .scaleEffect(x: 0.7, anchor: .trailing)
                    .frame(width: 90)
                }
            }
        }
    }

    // MARK: - Content Area

    var contentArea: some View {
        HStack(spacing: 0) {
            // Left sidebar with navigation
            sidebar

            // Main content
            contentForSelectedFilter
                .padding(.leading, 20)
        }
    }

    // MARK: - Sidebar

    private var sidebar: some View {
        VStack(spacing: 8) {
            ForEach(MessageFilter.allCases) { filter in
                filterButton(for: filter)
            }

            newMessageButton

            Spacer()
        }
        .frame(width: 100)
        .padding(.leading, 8)
    }

    private func filterButton(for filter: MessageFilter) -> some View {
        Button {
            withAnimation(.spring(response: 0.3)) {
                selectedFilter = filter
            }
            HapticFeedback.light()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 30)
                    .fill(selectedFilter == filter ? Color.lcarOrange : filter.color)
                    .frame(height: 80)

                VStack(spacing: 4) {
                    Text(filter.title)
                        .font(.custom("HelveticaNeue-CondensedBold", size: 16))
                        .foregroundStyle(Color.lcarBlack)
                        .minimumScaleFactor(0.6)

                    Text(String(format: "%02d", filter.rawValue))
                        .font(.custom("HelveticaNeue-CondensedBold", size: 12))
                        .foregroundStyle(Color.lcarBlack.opacity(0.6))
                }
                .scaleEffect(x: 0.7, anchor: .center)
            }
        }
    }

    private var newMessageButton: some View {
        Button {
            showingCreateMessage = true
            HapticFeedback.light()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 30)
                    .fill(Color.lcarViolet)
                    .frame(height: 80)

                VStack(spacing: 4) {
                    Text("NEW")
                        .font(.custom("HelveticaNeue-CondensedBold", size: 16))
                        .foregroundStyle(Color.lcarBlack)

                    Image(systemName: "square.and.pencil")
                        .font(.system(size: 14))
                        .foregroundStyle(Color.lcarBlack.opacity(0.6))
                }
                .scaleEffect(x: 0.7, anchor: .center)
            }
        }
    }

    // MARK: - Filter Content

    var contentForSelectedFilter: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Title
                Text(selectedFilter.title)
                    .font(.custom("HelveticaNeue-CondensedBold", size: 28))
                    .foregroundStyle(Color.lcarOrange)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)

                // Description
                Text(selectedFilter.description)
                    .font(.system(size: 14))
                    .foregroundStyle(Color.lcarWhite.opacity(0.8))
                    .lineLimit(3)
                    .multilineTextAlignment(.leading)

                Divider()
                    .background(Color.lcarOrange.opacity(0.3))
                    .padding(.vertical, 8)

                // Content
                messagesContent()
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
        }
    }
}
