//
//  LCARSSplashView.swift
//  Subspace
//
//  Created by Clifton Baggerman on 04/10/2025.
//

import SwiftUI
import LCARSComponents

/// LCARS-themed splash screen
struct LCARSSplashView: View {

    // MARK: - Properties

    @State private var scale: CGFloat = 0.7
    @State private var opacity: Double = 0
    @State private var codeOpacity: Double = 0
    @State private var panelOffset: CGFloat = -200

    // MARK: - Body

    var body: some View {
        ZStack {
            // Black background
            Color.lcarBlack
                .ignoresSafeArea()

            // Animated side panels
            HStack(spacing: 0) {
                VStack(spacing: 8) {
                    LCARSPanel(color: .lcarOrange, height: 100, cornerRadius: 40)
                    LCARSPanel(color: .lcarPink, height: 80, cornerRadius: 40)
                    LCARSPanel(color: .lcarViolet, height: 120, cornerRadius: 40)
                    Spacer()
                }
                .frame(width: 60)
                .offset(x: panelOffset)

                Spacer()

                VStack(spacing: 8) {
                    Spacer()
                    LCARSPanel(color: .lcarTan, height: 120, cornerRadius: 40)
                    LCARSPanel(color: .lcarPlum, height: 80, cornerRadius: 40)
                    LCARSPanel(color: .lcarLightOrange, height: 100, cornerRadius: 40)
                }
                .frame(width: 60)
                .offset(x: -panelOffset)
            }
            .padding(.horizontal, 20)

            // Center content
            VStack(spacing: 24) {
                // Icon
                Image(systemName: "network")
                    .font(.system(size: 100))
                    .foregroundStyle(Color.lcarOrange)
                    .scaleEffect(scale)
                    .shadow(color: Color.lcarOrange.opacity(0.5), radius: 20, x: 0, y: 0)

                // App name
                VStack(spacing: 8) {
                    Text("SUBSPACE")
                        .font(.custom("HelveticaNeue-CondensedBold", size: 48))
                        .foregroundStyle(Color.lcarOrange)
                        .scaleEffect(x: 0.9, anchor: .center)
                        .opacity(opacity)

                    Text("COMMUNICATIONS NETWORK")
                        .font(.custom("HelveticaNeue-CondensedBold", size: 16))
                        .foregroundStyle(Color.lcarWhite.opacity(0.7))
                        .opacity(opacity)

                    // LCARS code
                    Text("LCARS \(LCARSUtilities.randomDigits(5))")
                        .font(.custom("HelveticaNeue-CondensedBold", size: 14))
                        .foregroundStyle(Color.lcarOrange.opacity(0.6))
                        .scaleEffect(x: 0.8, anchor: .center)
                        .opacity(codeOpacity)
                }
            }
        }
        .onAppear {
            // Staggered animations
            withAnimation(.spring(response: 0.8, dampingFraction: 0.6)) {
                scale = 1.0
            }

            withAnimation(.easeOut(duration: 0.6).delay(0.3)) {
                opacity = 1.0
            }

            withAnimation(.easeOut(duration: 0.4).delay(0.6)) {
                codeOpacity = 1.0
            }

            withAnimation(.spring(response: 1.0, dampingFraction: 0.7)) {
                panelOffset = 0
            }
        }
    }
}

#Preview {
    LCARSSplashView()
}
