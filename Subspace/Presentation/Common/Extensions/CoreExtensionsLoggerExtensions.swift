//
//  LoggerExtensions.swift
//  Subspace
//
//  Created by Clifton Baggerman on 03/10/2025.
//

import Foundation
import os

/// Extensions for structured logging across the app
extension Logger {
    
    /// Creates a logger for the main app subsystem
    /// - Parameter category: The logging category (e.g., "Network", "Authentication")
    /// - Returns: Configured Logger instance
    static func app(category: String) -> Logger {
        Logger(
            subsystem: Bundle.main.bundleIdentifier ?? "SquareEnix",
            category: category
        )
    }
    
    /// Log network requests with structured data
    /// - Parameters:
    ///   - method: HTTP method
    ///   - url: Request URL
    ///   - statusCode: Response status code (optional)
    func logNetworkRequest(
        method: String,
        url: URL,
        statusCode: Int? = nil
    ) {
        if let statusCode = statusCode {
            self.info("🌐 \(method) \(url.absoluteString) → \(statusCode)")
        } else {
            self.debug("🌐 \(method) \(url.absoluteString)")
        }
    }
    
    /// Log user actions with consistent formatting
    /// - Parameters:
    ///   - action: The action performed
    ///   - context: Additional context
    func logUserAction(_ action: String, context: String? = nil) {
        if let context = context {
            self.info("👤 User: \(action) (\(context))")
        } else {
            self.info("👤 User: \(action)")
        }
    }
    
    /// Log performance metrics
    /// - Parameters:
    ///   - operation: The operation being measured
    ///   - duration: Time taken in milliseconds
    func logPerformance(operation: String, duration: TimeInterval) {
        let durationMs = Int(duration * 1000)
        self.info("⏱️ Performance: \(operation) took \(durationMs)ms")
    }
}