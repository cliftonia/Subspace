//
//  NetworkError.swift
//  Subspace
//
//  Created by Clifton Baggerman on 03/10/2025.
//

import Foundation

/// Network-related errors with localized descriptions
enum NetworkError: Error, LocalizedError, CaseIterable, Sendable {
    case noConnection
    case timeout
    case serverError(code: Int)
    case invalidResponse
    case decodingFailed
    case unknown
    
    // MARK: - CaseIterable Conformance
    
    static var allCases: [NetworkError] {
        [.noConnection, .timeout, .serverError(code: 500), .invalidResponse, .decodingFailed, .unknown]
    }
    
    // MARK: - LocalizedError Conformance
    
    var errorDescription: String? {
        switch self {
        case .noConnection:
            return "No internet connection available"
        case .timeout:
            return "Request timed out"
        case .serverError(let code):
            return "Server error occurred (Code: \(code))"
        case .invalidResponse:
            return "Invalid response received"
        case .decodingFailed:
            return "Failed to process server response"
        case .unknown:
            return "An unknown error occurred"
        }
    }
    
    var failureReason: String? {
        switch self {
        case .noConnection:
            return "The device is not connected to the internet"
        case .timeout:
            return "The server took too long to respond"
        case .serverError:
            return "The server encountered an internal error"
        case .invalidResponse:
            return "The server response was malformed"
        case .decodingFailed:
            return "The data format was unexpected"
        case .unknown:
            return "An unexpected error occurred"
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .noConnection:
            return "Check your internet connection and try again"
        case .timeout:
            return "Try again in a moment"
        case .serverError:
            return "Try again later or contact support if the problem persists"
        case .invalidResponse, .decodingFailed:
            return "Try again or contact support if the problem persists"
        case .unknown:
            return "Try restarting the app"
        }
    }
}