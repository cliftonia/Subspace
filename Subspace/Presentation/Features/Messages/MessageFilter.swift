//
//  MessageFilter.swift
//  Subspace
//
//  Created by Clifton Baggerman on 06/10/2025.
//

import LCARSComponents
import SwiftUI

/// Message filter options
enum MessageFilter: Int, CaseIterable, Identifiable {
    case all = 1
    case unread = 2
    case priority = 3
    case archived = 4

    var id: Int { rawValue }

    var title: String {
        switch self {
        case .all: return "ALL"
        case .unread: return "UNREAD"
        case .priority: return "PRIORITY"
        case .archived: return "ARCHIVE"
        }
    }

    var code: Int { rawValue }

    var headerTitle: String {
        switch self {
        case .all: return "ALL MESSAGES"
        case .unread: return "UNREAD MESSAGES"
        case .priority: return "PRIORITY MESSAGES"
        case .archived: return "ARCHIVED MESSAGES"
        }
    }

    var description: String {
        switch self {
        case .all: return "Displaying all communications from all sources"
        case .unread: return "Messages awaiting your attention"
        case .priority: return "High-priority alerts and critical notifications"
        case .archived: return "Previously archived communications"
        }
    }

    var sectionTitle: String {
        switch self {
        case .all: return "Messages"
        case .unread: return "Unread"
        case .priority: return "Priority Alerts"
        case .archived: return "Archive"
        }
    }

    var emptyMessage: String {
        switch self {
        case .all: return "No communications received"
        case .unread: return "All messages have been read"
        case .priority: return "No priority alerts at this time"
        case .archived: return "No archived messages"
        }
    }

    /// Whether a message belongs under this filter
    /// - Parameter message: The message to test
    /// - Returns: True if the message should be shown
    func includes(_ message: MessageResponse) -> Bool {
        let isArchived = message.isArchived ?? false

        switch self {
        case .all:
            return !isArchived
        case .unread:
            return !isArchived && !message.isRead
        case .priority:
            return !isArchived && message.kind.lowercased() == "error"
        case .archived:
            return isArchived
        }
    }

    var color: Color {
        switch self {
        case .all: return .lcarOrange
        case .unread: return .lcarViolet
        case .priority: return .lcarPlum
        case .archived: return .lcarTan
        }
    }
}
