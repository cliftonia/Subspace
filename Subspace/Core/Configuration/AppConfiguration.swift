//
//  AppConfiguration.swift
//  Subspace
//
//  Created by Clifton Baggerman on 25/11/2025.
//

import Foundation

/// Centralized app configuration for environment-based settings
enum AppConfiguration {
    // MARK: - Environment

    /// Current build environment
    static var environment: Environment {
        #if DEBUG
        return .development
        #else
        return .production
        #endif
    }

    enum Environment {
        case development
        case staging
        case production
    }

    // MARK: - API Configuration

    /// Base URL for REST API
    static var apiBaseURL: URL {
        let urlString = ProcessInfo.processInfo.environment["API_BASE_URL"]
            ?? defaultAPIBaseURL

        guard let url = URL(string: urlString) else {
            preconditionFailure("Invalid API base URL: \(urlString)")
        }
        return url
    }

    /// Base URL for WebSocket connections
    static var webSocketURL: URL {
        let urlString = ProcessInfo.processInfo.environment["WEBSOCKET_URL"]
            ?? defaultWebSocketURL

        guard let url = URL(string: urlString) else {
            preconditionFailure("Invalid WebSocket URL: \(urlString)")
        }
        return url
    }

    // MARK: - Default URLs

    private static var defaultAPIBaseURL: String {
        switch environment {
        case .development:
            return "http://localhost:8080/api/v1"
        case .staging:
            return "https://staging-api.subspace.app/api/v1"
        case .production:
            return "https://api.subspace.app/api/v1"
        }
    }

    private static var defaultWebSocketURL: String {
        switch environment {
        case .development:
            return "ws://localhost:8080/ws"
        case .staging:
            return "wss://staging-api.subspace.app/ws"
        case .production:
            return "wss://api.subspace.app/ws"
        }
    }

    // MARK: - Timeouts

    enum Timeout {
        static let request: TimeInterval = 30
        static let resource: TimeInterval = 60
        static let webSocketPing: TimeInterval = 30
        static let webSocketReconnect: TimeInterval = 3
    }
}
