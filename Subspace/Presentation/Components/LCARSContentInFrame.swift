//
//  LCARSContentInFrame.swift
//  Subspace
//
//  Created by Clifton Baggerman on 05/10/2025.
//

import SwiftUI

/// Simple LCARS frame with content positioned within the left panel styling
struct LCARSContentInFrame<Content: View>: View {

    // MARK: - Properties

    private let topColors: [Color]
    private let bottomColors: [Color]
    private let topTitle: String
    private let bottomTitle: String
    private let topCode: String
    private let bottomCode: String
    private let bottomLabels: [(String, String)]
    private let content: Content
    private let contentWidth: CGFloat
    private let contentHeight: CGFloat

    // MARK: - Initialization

    init(
        topColors: [Color],
        bottomColors: [Color],
        topTitle: String,
        bottomTitle: String,
        topCode: String,
        bottomCode: String,
        bottomLabels: [(String, String)] = [],
        contentWidth: CGFloat = 280,
        contentHeight: CGFloat = 400,
        @ViewBuilder content: () -> Content
    ) {
        self.topColors = topColors
        self.bottomColors = bottomColors
        self.topTitle = topTitle
        self.bottomTitle = bottomTitle
        self.topCode = topCode
        self.bottomCode = bottomCode
        self.bottomLabels = bottomLabels
        self.contentWidth = contentWidth
        self.contentHeight = contentHeight
        self.content = content()
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

                // Content positioned within frame
                content
                    .frame(width: contentWidth)
                    .offset(x: 50, y: 60)
            }
        }
        .ignoresSafeArea()
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
                    accentBar(colors: topColors)
                }
                .overlay(alignment: .leading) {
                    VStack(alignment: .trailing, spacing: 15) {
                        Text("LCARS \(randomDigits(5))")
                        Text("\(topCode)-\(randomDigits(6))")
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
                .overlay(alignment: .trailing) {
                    statsGrid
                        .padding(.top, 40)
                }
            }
        }
    }

    private var statsGrid: some View {
        Grid(alignment: .trailing) {
            ForEach(0..<7) { row in
                GridRow {
                    ForEach(0..<5) { _ in
                        Text(randomDigits(Int.random(in: 1...6)))
                            .foregroundStyle((row == 2 || row == 5) ? Color.lcarWhite : topColors.first ?? .lcarOrange)
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
                    ForEach(Array(bottomLabels.enumerated()), id: \.offset) { index, label in
                        if index < bottomColors.count {
                            bottomColors[index]
                                .frame(height: frameHeight(for: index, total: bottomLabels.count))
                                .overlay(alignment: labelAlignment(for: index, total: bottomLabels.count)) {
                                    commonLabel(prefix: label.0)
                                        .padding(labelPadding(for: index, total: bottomLabels.count))
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
                    accentBar(colors: bottomColors, isTop: false)
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

    // MARK: - Helpers

    private func accentBar(colors: [Color], isTop: Bool = true) -> some View {
        ZStack {
            Color.lcarBlack
            if isTop {
                HStack(spacing: 5) {
                    ForEach(0..<min(colors.count, 4), id: \.self) { index in
                        if index == 0 {
                            colors[index]
                                .frame(width: 20)
                                .padding(.leading, 5)
                        } else if index == 1 {
                            colors[index]
                                .frame(width: 50)
                        } else if index == colors.count - 1 {
                            colors[index]
                                .frame(width: 20)
                        } else {
                            colors[index]
                        }
                    }
                }
            } else {
                HStack(alignment: .top, spacing: 5) {
                    ForEach(0..<min(colors.count, 4), id: \.self) { index in
                        if index == 0 {
                            colors[index]
                                .frame(width: 20)
                                .padding(.leading, 5)
                        } else if index == 1 {
                            colors[index]
                                .frame(width: 50, height: 10)
                        } else if index == colors.count - 1 {
                            colors[index]
                                .frame(width: 20)
                        } else {
                            colors[index]
                        }
                    }
                }
            }
        }
        .frame(width: 200, height: 20)
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

    private func frameHeight(for index: Int, total: Int) -> CGFloat? {
        switch index {
        case 0: return 100
        case 1: return 200
        case 2: return 50
        default: return nil
        }
    }

    private func labelAlignment(for index: Int, total: Int) -> Alignment {
        switch index {
        case 0: return .bottomLeading
        case 1: return .bottomLeading
        case 2: return .leading
        default: return .topLeading
        }
    }

    private func labelPadding(for index: Int, total: Int) -> EdgeInsets {
        switch index {
        case 0, 1: return EdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 0)
        case 2: return EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        default: return EdgeInsets(top: 5, leading: 0, bottom: 0, trailing: 0)
        }
    }

    private func randomDigits(_ count: Int) -> String {
        (1...count).map { _ in "\(Int.random(in: 0...9))" }.joined()
    }
}
