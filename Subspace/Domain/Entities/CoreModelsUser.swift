//
//  User.swift
//  Subspace
//
//  Created by Clifton Baggerman on 03/10/2025.
//

import Foundation

/// User model with type-safe identifiers and backend compatibility
nonisolated struct User: Codable, Identifiable, Sendable {
    // MARK: - Type Definitions

    typealias UserID = String

    // MARK: - Properties

    let id: UserID
    let name: String
    let email: String
    let avatarURL: URL?
    let createdAt: Date

    // MARK: - Computed Properties

    var initials: String {
        let components = name.components(separatedBy: " ")
        let initials = components.compactMap { $0.first }.map(String.init)
        return initials.prefix(2).joined()
    }

    var displayName: String {
        name.isEmpty ? email : name
    }

    // MARK: - Coding Keys

    nonisolated enum CodingKeys: String, CodingKey {
        case id
        case name
        case email
        case avatarURL = "avatarUrl"
        case createdAt
    }
}

// MARK: - Mock Data

extension User {
    static let mockUser = User(
        id: "user-123",
        name: "John Doe",
        email: "john.doe@example.com",
        avatarURL: URL(string: "https://example.com/avatar.jpg"),
        createdAt: Date()
    )

    /// Sample users for testing and previews
    static let samples: [User] = [
        User(
            id: "user-1",
            name: "Alice Johnson",
            email: "alice.johnson@subspace.network",
            avatarURL: nil,
            createdAt: Date().addingTimeInterval(-86400 * 10)
        ),
        User(
            id: "user-2",
            name: "Bob Smith",
            email: "bob.smith@subspace.network",
            avatarURL: URL(string: "https://example.com/bob-avatar.jpg"),
            createdAt: Date().addingTimeInterval(-86400 * 25)
        ),
        User(
            id: "user-3",
            name: "Carol Williams",
            email: "carol.williams@subspace.network",
            avatarURL: nil,
            createdAt: Date().addingTimeInterval(-86400 * 45)
        )
    ]
}
