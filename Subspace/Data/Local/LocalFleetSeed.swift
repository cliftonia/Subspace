//
//  LocalFleetSeed.swift
//  Subspace
//
//  Created by Clifton Baggerman on 30/10/2026.
//

import Foundation

/// The crew and messages a new local fleet starts with
nonisolated enum LocalFleetSeed {
    // MARK: - Crew

    private struct CrewMember {
        let id: String
        let name: String
        let email: String
        let password: String
    }

    private static let crew: [CrewMember] = [
        CrewMember(id: "picard", name: "Jean-Luc Picard", email: "picard@starfleet.com", password: "engage"),
        CrewMember(id: "riker", name: "William Riker", email: "riker@starfleet.com", password: "number1"),
        CrewMember(id: "data", name: "Data", email: "data@starfleet.com", password: "spot"),
        CrewMember(id: "laforge", name: "Geordi La Forge", email: "laforge@starfleet.com", password: "warpcore"),
        CrewMember(id: "worf", name: "Worf", email: "worf@starfleet.com", password: "honor"),
        CrewMember(id: "crusher", name: "Beverly Crusher", email: "crusher@starfleet.com", password: "sickbay"),
        CrewMember(id: "troi", name: "Deanna Troi", email: "troi@starfleet.com", password: "chocolate"),
        CrewMember(id: "demo", name: "Demo User", email: "demo@example.com", password: "password")
    ]

    private static let replies = [
        "LT. CMDR. DATA: Transmission received and logged. Subspace signal integrity is nominal.",
        "CMDR. LA FORGE: Got it. Rerouting through the secondary array now.",
        "LT. WORF: Message acknowledged. Tactical systems stand ready.",
        "CMDR. RIKER: Understood. Keep me posted.",
        "DR. CRUSHER: Received. Sickbay is standing by."
    ]

    // MARK: - Briefing

    /// The parts of a message chosen by whoever writes it
    struct MessageDraft {
        let content: String
        let kind: String
        let isRead: Bool
    }

    private struct BriefingEntry {
        let draft: MessageDraft
        let age: TimeInterval
    }

    private static let briefing: [BriefingEntry] = [
        BriefingEntry(
            draft: MessageDraft(content: "Welcome aboard. Your Subspace access has been activated.", kind: "success", isRead: false),
            age: 300
        ),
        BriefingEntry(
            draft: MessageDraft(
                content: "Red alert drill scheduled for 0900 hours. All departments report readiness.",
                kind: "warning",
                isRead: false
            ),
            age: 1800
        ),
        BriefingEntry(
            draft: MessageDraft(
                content: "Warp core efficiency holding at 98 percent after the latest plasma injector alignment.",
                kind: "info",
                isRead: false
            ),
            age: 7200
        ),
        BriefingEntry(
            draft: MessageDraft(
                content: "Sensor sweep detected an unidentified subspace anomaly in sector 001.",
                kind: "warning",
                isRead: false
            ),
            age: 14400
        ),
        BriefingEntry(
            draft: MessageDraft(content: "Primary EPS conduit fault on deck 12. Repair team dispatched.", kind: "error", isRead: true),
            age: 86400
        ),
        BriefingEntry(
            draft: MessageDraft(content: "Duty roster updated for the coming week.", kind: "info", isRead: true),
            age: 172800
        )
    ]

    // MARK: - Factories

    static func accounts(now: Date) -> [LocalFleetAccount] {
        crew.enumerated().map { index, member in
            LocalFleetAccount(
                user: User(
                    id: member.id,
                    name: member.name,
                    email: member.email,
                    avatarURL: nil,
                    createdAt: now.addingTimeInterval(-86400 * Double(400 - index * 37))
                ),
                password: member.password
            )
        }
    }

    static func messages(for userId: String, now: Date) -> [LocalFleetMessage] {
        briefing.map { entry in
            message(for: userId, draft: entry.draft, at: now.addingTimeInterval(-entry.age))
        }
    }

    static func message(for userId: String, draft: MessageDraft, at date: Date) -> LocalFleetMessage {
        LocalFleetMessage(
            id: UUID().uuidString.lowercased(),
            userId: userId,
            content: draft.content,
            kind: draft.kind,
            isRead: draft.isRead,
            isArchived: false,
            createdAt: timestamp(date),
            updatedAt: timestamp(date)
        )
    }

    static func reply(to userId: String, sequence: Int, at date: Date) -> LocalFleetMessage {
        let draft = MessageDraft(content: replies[sequence % replies.count], kind: "success", isRead: false)
        return message(for: userId, draft: draft, at: date)
    }

    static func timestamp(_ date: Date) -> String {
        ISO8601DateFormatter().string(from: date)
    }
}
