//
//  APIModels.swift
//  Subspace
//
//  Created by Clifton Baggerman on 03/10/2025.
//

import Foundation

// MARK: - API Response Wrapper

/// Generic wrapper for list responses from the API
nonisolated struct ListResponse<T: Decodable & Sendable>: Decodable, Sendable {
    let data: [T]
    let limit: Int
    let offset: Int
}

// MARK: - Message Response

/// API response model for messages
nonisolated struct MessageResponse: Decodable, Sendable, Identifiable {
    let id: String
    let userId: String
    let content: String
    let kind: String
    let isRead: Bool
    let createdAt: String
    let updatedAt: String
}

// MARK: - Unread Count Response

/// API response for unread message count
nonisolated struct UnreadCountResponse: Decodable, Sendable {
    let unreadCount: Int
}
