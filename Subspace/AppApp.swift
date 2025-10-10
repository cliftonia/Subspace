//
//  App.swift
//  Subspace
//
//  Created by Clifton Baggerman on 03/10/2025.
//

import os
import SwiftUI

/// Main application entry point with proper logging and configuration
@main
struct SubspaceApp: App {
    // MARK: - Properties

    private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "Subspace",
        category: "App"
    )

    // MARK: - Body

    var body: some Scene {
        WindowGroup {
            AuthCoordinator()
                .onAppear {
                    logger.info("Subspace app launched")
                    setupGlobalConfiguration()
                }
        }
    }

    // MARK: - Private Methods

    private func setupGlobalConfiguration() {
        // Configure app-wide settings here
        logger.debug("Global configuration completed")
    }
}
