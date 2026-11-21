//
//  LCARSOnboardingView.swift
//  Subspace
//
//  Created by Clifton Baggerman on 04/10/2025.
//

import LCARSComponents
import SwiftUI

/// LCARS-themed onboarding screen
struct LCARSOnboardingView: View {
    // MARK: - Types

    private struct Page: Identifiable {
        let title: String
        let description: String
        let color: Color

        var id: String { title }
    }

    // MARK: - Properties

    @State private var currentPage = 0
    var onComplete: () -> Void = {}

    private let pages = [
        Page(
            title: "SUBSPACE COMMS",
            description: "Send and receive transmissions across the fleet from the COMMS panel.",
            color: .lcarViolet
        ),
        Page(
            title: "PERSONNEL",
            description: "Browse the crew directory and open any officer's service record.",
            color: .lcarTan
        ),
        Page(
            title: "SENSORS",
            description: "Plot the long range thermal forecast in four display modes.",
            color: .lcarBlue
        ),
        Page(
            title: "ACCESS GRANTED",
            description: "Your console is ready. Welcome aboard.",
            color: .lcarOrange
        )
    ]

    // MARK: - Body

    var body: some View {
        LCARSConsole(header: header) {
            LCARSArmBlocks(seed: "orientation")
        } content: {
            VStack(alignment: .leading, spacing: 16) {
                TabView(selection: $currentPage) {
                    ForEach(Array(pages.enumerated()), id: \.element.id) { index, page in
                        pageContent(page)
                            .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .onChange(of: currentPage) { _, _ in
                    HapticFeedback.selection()
                }

                Button(isLastPage ? "Begin" : "Continue", action: advance)
                    .buttonStyle(.lcars(pages[currentPage].color))
                    .padding(.bottom, 16)
            }
        }
    }

    // MARK: - Subviews

    private var header: LCARSConsoleHeader {
        LCARSConsoleHeader(
            title: "ORIENTATION",
            code: "\(currentPage + 1) OF \(pages.count)",
            accent: pages[currentPage].color,
            secondary: .lcarPink,
            railColors: [.lcarOrange, .lcarTan, .lcarViolet, .lcarGold]
        )
    }

    private func pageContent(_ page: Page) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            LCARSDataCascade(seed: page.title)

            Text(page.title)
                .font(.lcars(38, relativeTo: .title))
                .foregroundStyle(page.color)
                .lineLimit(1)
                .minimumScaleFactor(0.6)
                .accessibilityAddTraits(.isHeader)

            Text(page.description)
                .font(.lcarsBody(19))
                .foregroundStyle(Color.lcarWhite)
                .fixedSize(horizontal: false, vertical: true)

            Color.clear
        }
    }

    // MARK: - Methods

    private var isLastPage: Bool {
        currentPage == pages.count - 1
    }

    private func advance() {
        guard !isLastPage else {
            HapticFeedback.success()
            onComplete()
            return
        }

        withAnimation(.easeInOut(duration: 0.3)) {
            currentPage += 1
        }
    }
}

#Preview {
    LCARSOnboardingView()
}
