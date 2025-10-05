//
//  AppleAuthService.swift
//  Subspace
//
//  Created by Clifton Baggerman on 04/10/2025.
//

import Foundation
import AuthenticationServices
import os

// MARK: - Apple Auth Result

struct AppleAuthResult: Sendable {
    let userId: String
    let email: String?
    let fullName: PersonNameComponents?
    let identityToken: String
    let authorizationCode: String
}

// MARK: - Apple Auth Service Protocol

protocol AppleAuthServiceProtocol: Sendable {
    func signIn() async throws -> AppleAuthResult
}

// MARK: - Apple Auth Service

@MainActor
final class AppleAuthService: NSObject, AppleAuthServiceProtocol {

    // MARK: - Properties

    private let logger = Logger.app(category: "AppleAuthService")
    private var authContinuation: CheckedContinuation<AppleAuthResult, Error>?

    // MARK: - Public Methods

    /// Initiates Sign in with Apple flow
    func signIn() async throws -> AppleAuthResult {
        logger.info("Starting Sign in with Apple")

        return try await withCheckedThrowingContinuation { continuation in
            authContinuation = continuation

            let request = ASAuthorizationAppleIDProvider().createRequest()
            request.requestedScopes = [.fullName, .email]

            let controller = ASAuthorizationController(authorizationRequests: [request])
            controller.delegate = self
            controller.presentationContextProvider = self
            controller.performRequests()
        }
    }
}

// MARK: - ASAuthorizationControllerDelegate

extension AppleAuthService: ASAuthorizationControllerDelegate {

    nonisolated func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    ) {
        Task { @MainActor in
            guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else {
                logger.error("Invalid credential type")
                authContinuation?.resume(throwing: AppleAuthError.invalidCredential)
                authContinuation = nil
                return
            }

            guard let tokenData = credential.identityToken,
                  let identityToken = String(data: tokenData, encoding: .utf8),
                  let codeData = credential.authorizationCode,
                  let authorizationCode = String(data: codeData, encoding: .utf8) else {
                logger.error("Missing required token data")
                authContinuation?.resume(throwing: AppleAuthError.missingTokenData)
                authContinuation = nil
                return
            }

            let result = AppleAuthResult(
                userId: credential.user,
                email: credential.email,
                fullName: credential.fullName,
                identityToken: identityToken,
                authorizationCode: authorizationCode
            )

            logger.info("Apple authentication successful for user: \\(credential.user)")
            authContinuation?.resume(returning: result)
            authContinuation = nil
        }
    }

    nonisolated func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithError error: Error
    ) {
        Task { @MainActor in
            logger.error("Apple authentication failed: \\(error.localizedDescription)")

            if let authError = error as? ASAuthorizationError {
                switch authError.code {
                case .canceled:
                    authContinuation?.resume(throwing: AppleAuthError.userCancelled)
                case .failed:
                    authContinuation?.resume(throwing: AppleAuthError.authorizationFailed)
                case .invalidResponse:
                    authContinuation?.resume(throwing: AppleAuthError.invalidResponse)
                case .notHandled:
                    authContinuation?.resume(throwing: AppleAuthError.notHandled)
                case .unknown:
                    authContinuation?.resume(throwing: AppleAuthError.unknown)
                @unknown default:
                    authContinuation?.resume(throwing: AppleAuthError.unknown)
                }
            } else {
                authContinuation?.resume(throwing: error)
            }

            authContinuation = nil
        }
    }
}

// MARK: - ASAuthorizationControllerPresentationContextProviding

extension AppleAuthService: ASAuthorizationControllerPresentationContextProviding {

    nonisolated func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = scene.windows.first else {
            return ASPresentationAnchor()
        }
        return window
    }
}

// MARK: - Apple Auth Error

enum AppleAuthError: LocalizedError, Sendable {
    case userCancelled
    case invalidCredential
    case missingTokenData
    case authorizationFailed
    case invalidResponse
    case notHandled
    case unknown

    var errorDescription: String? {
        switch self {
        case .userCancelled:
            return "Sign in was cancelled"
        case .invalidCredential:
            return "Invalid credential received"
        case .missingTokenData:
            return "Missing required authentication data"
        case .authorizationFailed:
            return "Authorization failed"
        case .invalidResponse:
            return "Invalid response from Apple"
        case .notHandled:
            return "Request not handled"
        case .unknown:
            return "An unknown error occurred"
        }
    }
}
