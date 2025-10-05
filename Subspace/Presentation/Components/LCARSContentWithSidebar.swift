//
//  LCARSContentWithSidebar.swift
//  Subspace
//
//  Created by Clifton Baggerman on 05/10/2025.
//

import SwiftUI

/// LCARS frame with left sidebar buttons and content area on the right
struct LCARSContentWithSidebar<Content: View, Item: Identifiable & Hashable>: View where Item: SidebarItemProtocol {

    // MARK: - Properties

    private let topColors: [Color]
    private let bottomColors: [Color]
    private let topTitle: String
    private let bottomTitle: String
    private let topCode: String
    private let bottomCode: String
    private let topLabels: [(String, String)]
    private let bottomLabels: [(String, String)]
    private let sidebarItems: [Item]
    @Binding private var selectedItem: Item
    private let content: (Item) -> Content

    // MARK: - Initialization

    init(
        topColors: [Color],
        bottomColors: [Color],
        topTitle: String,
        bottomTitle: String,
        topCode: String,
        bottomCode: String,
        topLabels: [(String, String)] = [],
        bottomLabels: [(String, String)] = [],
        sidebarItems: [Item],
        selectedItem: Binding<Item>,
        @ViewBuilder content: @escaping (Item) -> Content
    ) {
        self.topColors = topColors
        self.bottomColors = bottomColors
        self.topTitle = topTitle
        self.bottomTitle = bottomTitle
        self.topCode = topCode
        self.bottomCode = bottomCode
        self.topLabels = topLabels
        self.bottomLabels = bottomLabels
        self.sidebarItems = sidebarItems
        self._selectedItem = selectedItem
        self.content = content
    }

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

                // Sidebar + Content
                HStack(spacing: 0) {
                    // Left sidebar with buttons
                    sidebarButtons
                        .frame(width: 100)
                        .padding(.leading, 8)

                    // Main content
                    content(selectedItem)
                        .padding(.leading, 20)
                }
                .offset(x: 50, y: 60)
            }
        }
        .ignoresSafeArea()
    }

    // MARK: - Sidebar Buttons

    private var sidebarButtons: some View {
        VStack(spacing: 8) {
            ForEach(sidebarItems) { item in
                Button {
                    withAnimation(.spring(response: 0.3)) {
                        selectedItem = item
                    }
                    HapticFeedback.light()
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 30)
                            .fill(selectedItem.id == item.id ? Color.lcarOrange : item.color)
                            .frame(height: 80)

                        VStack(spacing: 4) {
                            Text(item.title)
                                .font(.custom("HelveticaNeue-CondensedBold", size: 11))
                                .foregroundStyle(Color.lcarBlack)
                                .lineLimit(1)
                                .minimumScaleFactor(0.7)
                                .frame(maxWidth: .infinity, alignment: .trailing)

                            Text(String(format: "%02d", item.code) + "-\(LCARSUtilities.randomDigits(4))")
                                .font(.custom("HelveticaNeue-CondensedBold", size: 10))
                                .foregroundStyle(Color.lcarBlack)
                                .scaleEffect(x: 0.8, anchor: .trailing)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                        .padding(.horizontal, 8)
                        .padding(.trailing, 4)
                    }
                }
            }
            Spacer()
        }
    }

    // MARK: - Top Frame

    private var topFrame: some View {
        GeometryReader { geo in
            ZStack {
                VStack(spacing: 5) {
                    ForEach(0..<min(topColors.count, 3), id: \.self) { index in
                        topColors[index]
                    }
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
                    LCARSUtilities.accentBar(colors: topColors)
                }
                .overlay(alignment: .leading) {
                    VStack(alignment: .trailing, spacing: 15) {
                        Text("LCARS \(LCARSUtilities.randomDigits(5))")
                        Text("\(topCode)-\(LCARSUtilities.randomDigits(6))")
                    }
                    .font(.custom("HelveticaNeue-CondensedBold", size: 17))
                    .foregroundStyle(Color.lcarBlack)
                    .scaleEffect(x: 0.7, anchor: .trailing)
                    .frame(width: 90)
                }
                .overlay(alignment: .topTrailing) {
                    Text(topTitle)
                        .font(.custom("HelveticaNeue-CondensedBold", size: 35))
                        .padding(.top, 45)
                        .foregroundStyle(Color.lcarOrange)
                        .scaleEffect(x: 0.7, anchor: .trailing)
                }
            }
        }
    }

    // MARK: - Bottom Frame

    private var bottomFrame: some View {
        GeometryReader { geo in
            ZStack {
                VStack(alignment: .leading, spacing: 5) {
                    ForEach(Array(bottomLabels.enumerated()), id: \.offset) { index, label in
                        if index < bottomColors.count {
                            bottomColors[index]
                                .frame(height: LCARSUtilities.frameHeight(for: index, total: bottomLabels.count))
                                .overlay(alignment: LCARSUtilities.labelAlignment(for: index, total: bottomLabels.count)) {
                                    LCARSUtilities.commonLabel(prefix: label.0)
                                        .padding(LCARSUtilities.labelPadding(for: index, total: bottomLabels.count))
                                }
                        }
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
                    LCARSUtilities.accentBar(colors: bottomColors, isTop: false)
                }
                .overlay(alignment: .bottomTrailing) {
                    Text(bottomTitle)
                        .font(.custom("HelveticaNeue-CondensedBold", size: 35))
                        .padding(.bottom, 45)
                        .foregroundStyle(Color.lcarOrange)
                        .scaleEffect(x: 0.7, anchor: .trailing)
                }
            }
        }
    }
}

// MARK: - Sidebar Item Protocol

protocol SidebarItemProtocol {
    var id: Int { get }
    var title: String { get }
    var code: Int { get }
    var color: Color { get }
}
