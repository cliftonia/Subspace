//
//  RetryPolicy.swift
//  Subspace
//
//  Created by Clifton Baggerman on 03/10/2025.
//

import Foundation
import os

// MARK: - Retry Policy

/// Configurable retry policy with exponential backoff
struct RetryPolicy: Sendable {

    // MARK: - Properties

    let maxAttempts: Int
    let baseDelay: TimeInterval
    let maxDelay: TimeInterval
    let multiplier: Double

    private let logger = Logger.app(category: "RetryPolicy")

    // MARK: - Initialization

    init(
        maxAttempts: Int = 3,
        baseDelay: TimeInterval = 1.0,
        maxDelay: TimeInterval = 30.0,
        multiplier: Double = 2.0
    ) {
        self.maxAttempts = maxAttempts
        self.baseDelay = baseDelay
        self.maxDelay = maxDelay
        self.multiplier = multiplier
    }

    // MARK: - Static Configurations

    static let standard = RetryPolicy()
    static let aggressive = RetryPolicy(maxAttempts: 5, baseDelay: 0.5)
    static let conservative = RetryPolicy(maxAttempts: 2, baseDelay: 2.0)
    static let none = RetryPolicy(maxAttempts: 1)

    // MARK: - Retry Logic

    /// Execute operation with retry logic
    /// - Parameter operation: The async operation to retry
    /// - Returns: The result of the operation
    /// - Throws: The last error encountered if all retries fail
    func execute<T: Sendable>(
        _ operation: @Sendable () async throws -> T
    ) async throws -> T {
        var lastError: Error?
        var attempt = 0

        while attempt < maxAttempts {
            attempt += 1

            do {
                let result = try await operation()
                if attempt > 1 {
                    logger.info("Operation succeeded on attempt \(attempt)")
                }
                return result
            } catch {
                lastError = error

                // Check if error is retryable
                guard shouldRetry(error: error, attempt: attempt) else {
                    logger.error("Error not retryable: \(error.localizedDescription)")
                    throw error
                }

                // Calculate delay with exponential backoff
                let delay = calculateDelay(for: attempt)
                logger.warning("Attempt \(attempt) failed, retrying in \(delay)s...")

                // Wait before retrying
                try? await Task.sleep(for: .seconds(delay))
            }
        }

        // All retries exhausted
        logger.error("All \(maxAttempts) attempts failed")
        throw lastError ?? NetworkError.unknown
    }

    // MARK: - Private Methods

    private func shouldRetry(error: Error, attempt: Int) -> Bool {
        // Don't retry if we've reached max attempts
        guard attempt < maxAttempts else {
            return false
        }

        // Check if error is retryable
        if let networkError = error as? NetworkError {
            switch networkError {
            case .noConnection, .timeout:
                return true
            case .serverError(let code):
                // Retry on 5xx server errors, not 4xx client errors
                return code >= 500
            case .invalidResponse, .decodingFailed, .unknown:
                return false
            }
        }

        // Retry by default for unknown errors
        return true
    }

    private func calculateDelay(for attempt: Int) -> TimeInterval {
        let exponentialDelay = baseDelay * pow(multiplier, Double(attempt - 1))
        return min(exponentialDelay, maxDelay)
    }
}

// MARK: - Convenience Extensions

// Note: requestWithRetry method is implemented directly in APIClient class
// to avoid actor isolation conflicts
