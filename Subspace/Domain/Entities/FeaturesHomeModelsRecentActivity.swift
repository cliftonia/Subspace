//
//  RecentActivity.swift
//  Subspace
//
//  Created by Clifton Baggerman on 04/10/2025.
//

import Foundation

struct RecentActivity: Identifiable, Sendable {
    let id = UUID()
    let title: String
    let subtitle: String
    let icon: String
    let timeAgo: String

    static let samples: [RecentActivity] = [
        RecentActivity(
            title: "Profile Updated",
            subtitle: "Changed display name",
            icon: "person.circle",
            timeAgo: "2h ago"
        ),
        RecentActivity(
            title: "Settings Changed",
            subtitle: "Updated notifications",
            icon: "gear",
            timeAgo: "1d ago"
        )
    ]
}
