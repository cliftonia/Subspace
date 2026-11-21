//
//  LCARSSplashView.swift
//  Subspace
//
//  Created by Clifton Baggerman on 04/10/2025.
//

import LCARSComponents
import SwiftUI

/// Start-up screen, sharing the console frame so sign in follows without a jolt
struct LCARSSplashView: View {
    // MARK: - Properties

    private let header = LCARSConsoleHeader(
        title: "SUBSPACE",
        code: "LCARS \(LCARSUtilities.stableDigits("subspace", count: 5))",
        accent: .lcarOrange,
        secondary: .lcarPink,
        railColors: [.lcarOrange, .lcarTan, .lcarViolet, .lcarGold]
    )

    // MARK: - Body

    var body: some View {
        LCARSConsole(header: header) {
            LCARSArmBlocks(seed: "startup")
        } content: {
            VStack(alignment: .leading, spacing: 16) {
                Text("COMMUNICATIONS NETWORK")
                    .font(.lcars(30, relativeTo: .title))
                    .foregroundStyle(Color.lcarOrange)
                    .lineLimit(1)
                    .minimumScaleFactor(0.6)

                LCARSDataCascade(seed: "startup", rows: 6)

                Text("INITIALIZING")
                    .font(.lcars(22))
                    .foregroundStyle(Color.lcarViolet)
            }
        }
    }
}

#Preview {
    LCARSSplashView()
}
