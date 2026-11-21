//
//  ComponentShowcaseView.swift
//  ComponentLibrary
//
//  Created by Clifton Baggerman on 04/10/2025.
//

import LCARSComponents
import SwiftUI

/// Main showcase view, displaying every shared LCARS component inside the real console
struct ComponentShowcaseView: View {
    // MARK: - State

    @State private var selectedTab: ShowcaseTab = .buttons
    @State private var keyboardText = ""

    // MARK: - Body

    var body: some View {
        LCARSConsole(header: selectedTab.consoleHeader) {
            ForEach(ShowcaseTab.allCases) { tab in
                Button(tab.shortName) {
                    selectedTab = tab
                }
                .buttonStyle(.lcars(tab.color, form: .segment, isSelected: tab == selectedTab))
            }
        } content: {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text(selectedTab.description)
                        .font(.lcarsBody(16))
                        .foregroundStyle(Color.lcarWhite.opacity(0.8))
                        .fixedSize(horizontal: false, vertical: true)

                    tabContent
                }
                .padding(.bottom, 16)
            }
            .scrollIndicators(.hidden)
        }
    }

    // MARK: - Content

    @ViewBuilder private var tabContent: some View {
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
}

#Preview {
    ComponentShowcaseView()
}
