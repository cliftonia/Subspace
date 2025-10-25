//
//  FreshModels.swift
//  Subspace
//
//  Created by Clifton Baggerman on 03/10/2025.
//

import Foundation

/// Fresh message model to avoid any conflicts
nonisolated struct FreshMessageResponse: Codable, Sendable, Identifiable {
    let id: String
    let userId: String
    let content: String
    let kind: String
    let isRead: Bool
    let createdAt: String
    let updatedAt: String
}

/// Fresh user model to avoid any conflicts
struct FreshUser: Codable, Sendable, Identifiable {
    let id: String
    let name: String
    let email: String
    let avatarURL: URL?
    let createdAt: Date

    nonisolated enum CodingKeys: String, CodingKey {
        case id, name, email
        case avatarURL = "avatar_url"
        case createdAt = "created_at"
    }
}

/// Fresh list response wrapper
nonisolated struct FreshListResponse<T: Codable & Sendable>: Codable, Sendable {
    let data: [T]
    let total: Int
    let limit: Int
    let offset: Int
}
