//
//  ComponentShowcaseView.swift
//  ComponentLibrary
//
//  Created by Clifton Baggerman on 04/10/2025.
//

import SwiftUI
import LCARSComponents

/// Main showcase view displaying all LCARS components
struct ComponentShowcaseView: View {

    // MARK: - State

    @State private var selectedTab: ShowcaseTab = .buttons
    @State private var keyboardText = ""

    // MARK: - Body

    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color.lcarBlack
                    .ignoresSafeArea()

                VStack(spacing: 10) {
                    // Top frame
                    topFrame
                        .frame(height: max(geo.size.height / 5, 100))

                    // Content area
                    contentArea
                        .frame(height: max(geo.size.height * 0.8 - 10, 100))
                }
            }
        }
        .ignoresSafeArea()
    }

    // MARK: - Top Frame

    private var topFrame: some View {
        GeometryReader { geo in
            ZStack {
                VStack(spacing: 5) {
                    selectedTab.color
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
                    Text(selectedTab.title)
                        .font(.custom("HelveticaNeue-CondensedBold", size: 32))
                        .padding(.top, 50)
                        .padding(.trailing, 20)
                        .foregroundStyle(selectedTab.color)
                        .scaleEffect(x: 0.7, anchor: .trailing)
                }
                .overlay(alignment: .leading) {
                    VStack(alignment: .trailing, spacing: 10) {
                        Text("LCARS \(LCARSUtilities.randomDigits(5))")
                        Text(String(format: "%02d", selectedTab.rawValue) + "-\(LCARSUtilities.randomDigits(6))")
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

    private var contentArea: some View {
        HStack(spacing: 0) {
            // Left sidebar with navigation
            VStack(spacing: 8) {
                ForEach(ShowcaseTab.allCases) { tab in
                    Button {
                        withAnimation(.spring(response: 0.3)) {
                            selectedTab = tab
                        }
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 30)
                                .fill(selectedTab == tab ? Color.lcarOrange : tab.color)
                                .frame(height: 80)

                            VStack(spacing: 4) {
                                Text(tab.shortName)
                                    .font(.custom("HelveticaNeue-CondensedBold", size: 16))
                                    .foregroundStyle(Color.lcarBlack)
                                    .minimumScaleFactor(0.6)

                                Text(String(format: "%02d", tab.rawValue))
                                    .font(.custom("HelveticaNeue-CondensedBold", size: 12))
                                    .foregroundStyle(Color.lcarBlack.opacity(0.6))
                            }
                            .scaleEffect(x: 0.7, anchor: .center)
                        }
                    }
                }
            }
            .frame(width: 100)
            .padding(.leading, 8)

            // Main content
            contentForSelectedTab
                .padding(.leading, 20)
        }
    }

    // MARK: - Tab Content

    @ViewBuilder
    private var contentForSelectedTab: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Title
                Text(selectedTab.title)
                    .font(.custom("HelveticaNeue-CondensedBold", size: 28))
                    .foregroundStyle(Color.lcarOrange)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)

                // Description
                Text(selectedTab.description)
                    .font(.system(size: 14))
                    .foregroundStyle(Color.lcarWhite.opacity(0.8))
                    .lineLimit(3)
                    .multilineTextAlignment(.leading)

                Divider()
                    .background(Color.lcarOrange.opacity(0.3))
                    .padding(.vertical, 8)

                // Content
                switch selectedTab {
                case .colors:
                    ColorsShowcaseView()
                case .buttons:
                    ButtonsShowcaseView()
                case .panels:
                    PanelsShowcaseView()
                case .atoms:
                    AtomsShowcaseView()
                case .gauges:
                    GaugesShowcaseView()
                case .sounds:
                    SoundsShowcaseView()
                case .keyboard:
                    KeyboardShowcaseView(keyboardText: $keyboardText)
                case .utilities:
                    UtilitiesShowcaseView()
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
        }
    }
}

// MARK: - Preview

#Preview {
    ComponentShowcaseView()
}
