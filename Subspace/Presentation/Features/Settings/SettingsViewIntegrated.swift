//
//  LCARSSettingsViewIntegrated.swift
//  Subspace
//
//  Created by Clifton Baggerman on 04/10/2025.
//

import LCARSComponents
import os
import SwiftUI

/// Console configuration
struct LCARSSettingsViewIntegrated: View {
    // MARK: - Properties

    @Environment(AppDependencies.self)
    private var dependencies

    private let logger = Logger.app(category: "LCARSSettingsViewIntegrated")

    // MARK: - Body

    var body: some View {
        SettingsContentView(dependencies: dependencies)
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
