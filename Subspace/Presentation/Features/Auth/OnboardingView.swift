//
//  LCARSOnboardingView.swift
//  Subspace
//
//  Created by Clifton Baggerman on 04/10/2025.
//

import SwiftUI
import LCARSComponents

/// LCARS-themed onboarding screen
struct LCARSOnboardingView: View {

    // MARK: - Properties

    @State private var currentPage = 0
    var onComplete: () -> Void = {}

    private let pages: [OnboardingPage] = [
        OnboardingPage(
            title: "SECURE COMMUNICATIONS",
            description: "Real-time messaging with end-to-end encryption and WebSocket technology",
            systemImage: "message.fill",
            primaryColor: "lcarOrange",
            secondaryColor: "lcarPink"
        ),
        OnboardingPage(
            title: "USER DIRECTORY",
            description: "Browse and connect with personnel across the gaming network",
            systemImage: "person.3.fill",
            primaryColor: "lcarViolet",
            secondaryColor: "lcarPlum"
        ),
        OnboardingPage(
            title: "SYSTEM NOTIFICATIONS",
            description: "Stay informed with instant alerts and status updates",
            systemImage: "bell.badge.fill",
            primaryColor: "lcarTan",
            secondaryColor: "lcarLightOrange"
        ),
        OnboardingPage(
            title: "ACCESS GRANTED",
            description: "Your gateway to the Subspace communications network",
            systemImage: "network",
            primaryColor: "lcarOrange",
            secondaryColor: "lcarViolet"
        )
    ]

    // MARK: - Body

    var body: some View {
        ZStack {
            Color.lcarBlack
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Header with skip
                HStack {
                    Text("LCARS \(LCARSUtilities.randomDigits(5))")
                        .font(.custom("HelveticaNeue-CondensedBold", size: 14))
                        .foregroundStyle(Color.lcarOrange.opacity(0.6))
                        .scaleEffect(x: 0.8, anchor: .leading)

                    Spacer()

                    if currentPage < pages.count - 1 {
                        Button(action: skipOnboarding) {
                            Text("SKIP")
                                .font(.custom("HelveticaNeue-CondensedBold", size: 14))
                                .foregroundStyle(Color.lcarTan)
                        }
                    }
                }
                .padding(.horizontal, 32)
                .padding(.top, 60)

                // Page content
                TabView(selection: $currentPage) {
                    ForEach(Array(pages.enumerated()), id: \.element.id) { index, page in
                        OnboardingPageContentView(page: page)
                            .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .onChange(of: currentPage) { _, _ in
                    HapticFeedback.selection()
                }

                // Page indicators
                HStack(spacing: 12) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        RoundedRectangle(cornerRadius: 2)
                            .fill(index == currentPage ? Color.lcarOrange : Color.lcarWhite.opacity(0.3))
                            .frame(width: index == currentPage ? 24 : 8, height: 4)
                            .animation(.easeInOut(duration: 0.3), value: currentPage)
                    }
                }
                .padding(.bottom, 32)

                // Action button
                LCARSButton(
                    currentPage < pages.count - 1 ? "CONTINUE" : "BEGIN",
                    code: LCARSUtilities.randomDigits(4),
                    color: currentPage < pages.count - 1 ? Color.lcarViolet : Color.lcarOrange
                ) {
                    handleButtonAction()
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 48)
            }
        }
    }

    // MARK: - Methods

    private func handleButtonAction() {
        if currentPage < pages.count - 1 {
            withAnimation(.easeInOut(duration: 0.3)) {
                currentPage += 1
            }
            HapticFeedback.light()
        } else {
            HapticFeedback.success()
            onComplete()
        }
    }

    private func skipOnboarding() {
        withAnimation(.easeInOut(duration: 0.3)) {
            currentPage = pages.count - 1
        }
    }
}

// MARK: - Page Content View

struct OnboardingPageContentView: View {
    let page: OnboardingPage

    @State private var iconScale: CGFloat = 0.7
    @State private var textOpacity: Double = 0

    var body: some View {
        VStack(spacing: 40) {
            Spacer()

            // Icon with glow
            Image(systemName: page.systemImage)
                .font(.system(size: 100))
                .foregroundStyle(colorFromString(page.primaryColor))
                .scaleEffect(iconScale)
                .shadow(
                    color: colorFromString(page.primaryColor).opacity(0.5),
                    radius: 30,
                    x: 0,
                    y: 0
                )

            // Text content
            VStack(spacing: 16) {
                Text(page.title)
                    .font(.custom("HelveticaNeue-CondensedBold", size: 32))
                    .foregroundStyle(colorFromString(page.primaryColor))
                    .scaleEffect(x: 0.9, anchor: .center)
                    .multilineTextAlignment(.center)
                    .opacity(textOpacity)

                Text(page.description)
                    .font(.custom("HelveticaNeue", size: 16))
                    .foregroundStyle(Color.lcarWhite.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                    .opacity(textOpacity)
            }

            Spacer()
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.6)) {
                iconScale = 1.0
            }

            withAnimation(.easeIn(duration: 0.6).delay(0.2)) {
                textOpacity = 1.0
            }
        }
    }

    private func colorFromString(_ colorName: String) -> Color {
        switch colorName {
        case "lcarOrange": return .lcarOrange
        case "lcarPink": return .lcarPink
        case "lcarViolet": return .lcarViolet
        case "lcarPlum": return .lcarPlum
        case "lcarTan": return .lcarTan
        case "lcarLightOrange": return .lcarLightOrange
        default: return .lcarOrange
        }
    }
}

#Preview {
    LCARSOnboardingView()
}
