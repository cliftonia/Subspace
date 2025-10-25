//
//  LCARSSettingsViewIntegrated.swift
//  Subspace
//
//  Created by Clifton Baggerman on 04/10/2025.
//

import LCARSComponents
import os
import SwiftUI

/// LCARS-themed settings view with integrated design
struct LCARSSettingsViewIntegrated: View {
    // MARK: - Properties

    @Environment(AppDependencies.self)
    private var dependencies

    private let logger = Logger.app(category: "LCARSSettingsViewIntegrated")

    // MARK: - Body

    var body: some View {
        LCARSContentInFrame(
            topColors: [.lcarPlum, .lcarPink],
            bottomColors: [.lcarLightOrange, .lcarTan, .lcarViolet, .lcarOrange],
            topTitle: "CONFIGURATION",
            bottomTitle: "SYSTEM \(LCARSUtilities.randomDigits(3))",
            topCode: "CFG",
            bottomCode: "",
            bottomLabels: [("APP", ""), ("PRF", ""), ("SUP", ""), ("SYS", "")],
            contentWidth: 280,
            contentHeight: 400
        ) {
            SettingsContentView(dependencies: dependencies)
        }
        .onAppear {
            logger.logUserAction("Viewed LCARS Settings")
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        LCARSSettingsViewIntegrated()
            .environment(AppDependencies(userId: "preview-user-id"))
    }
}
