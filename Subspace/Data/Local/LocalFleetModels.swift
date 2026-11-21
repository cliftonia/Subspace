//
//  LocalFleetModels.swift
//  Subspace
//
//  Created by Clifton Baggerman on 30/10/2026.
//

import Foundation

// MARK: - Request and Response

/// An API request as seen by the local fleet
nonisolated struct LocalFleetRequest: Sendable {
    let method: String
    let pathComponents: [String]
    let bearerToken: String?
    let body: Data?
}

/// The local fleet's reply to a request
nonisolated struct LocalFleetResponse: Sendable {
    let statusCode: Int
    let body: Data
}

// MARK: - Stored State

/// A crew account, kept with its password because this backend runs entirely on the device
nonisolated struct LocalFleetAccount: Codable, Sendable {
    let user: User
    let password: String
}

/// A message as stored by the local fleet
nonisolated struct LocalFleetMessage: Codable, Sendable {
    let id: String
    let userId: String
    let content: String
    let kind: String
    var isRead: Bool
    var isArchived: Bool
    let createdAt: String
    var updatedAt: String
}

/// Everything the local fleet persists
nonisolated struct LocalFleetState: Codable, Sendable {
    var accounts: [LocalFleetAccount]
    var messages: [LocalFleetMessage]
}
