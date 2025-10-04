//
//  UsersViewModel.swift
//  Subspace
//
//  Created by Clifton Baggerman on 03/10/2025.
//

import SwiftUI
import Observation
import os

// MARK: - Users State

enum UsersState: Equatable {
    case idle
    case loading
    case loaded([User])
    case error(String)

    static func == (lhs: UsersState, rhs: UsersState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle):
            return true
        case (.loading, .loading):
            return true
        case (.loaded(let lhsUsers), .loaded(let rhsUsers)):
            return lhsUsers.map(\.id) == rhsUsers.map(\.id)
        case (.error(let lhsMessage), .error(let rhsMessage)):
            return lhsMessage == rhsMessage
        default:
            return false
        }
    }
}

// MARK: - Users View Model

/// ViewModel for users list screen
@MainActor
@Observable
final class UsersViewModel {

    // MARK: - Properties

    private(set) var state: UsersState = .idle
    private(set) var searchText = ""
    private(set) var isInteractionEnabled = true
    private(set) var isLoadingMore = false
    private(set) var hasMorePages = true

    // MARK: - Private Properties

    private let logger = Logger.app(category: "UsersViewModel")
    private var allUsers: [User] = []
    private let apiClient: APIClient
    private var currentOffset = 0
    private let pageSize = 20

    // MARK: - Computed Properties

    var filteredUsers: [User] {
        guard !searchText.isEmpty else {
            return allUsers
        }

        return allUsers.filter { user in
            user.name.localizedCaseInsensitiveContains(searchText) ||
            user.email.localizedCaseInsensitiveContains(searchText)
        }
    }

    // MARK: - Initialization

    init(apiClient: APIClient = APIClient()) {
        self.apiClient = apiClient
    }

    // MARK: - Public Methods

    /// Load initial users
    nonisolated func loadUsers() async {
        logger.info("Loading users")

        await MainActor.run {
            state = .loading
            isInteractionEnabled = false
            currentOffset = 0
            allUsers = []
        }

        do {
            let response = try await apiClient.fetchUsers()

            await MainActor.run {
                allUsers = response.data
                state = .loaded(response.data)
                currentOffset = response.data.count
                hasMorePages = response.data.count >= pageSize
            }
            HapticFeedback.success()
            logger.info("Loaded \(response.data.count) users")
        } catch {
            logger.error("Failed to load users: \(error.localizedDescription)")
            await MainActor.run {
                state = .error("Failed to load users")
            }
            HapticFeedback.error()
        }

        await MainActor.run {
            isInteractionEnabled = true
        }
    }

    /// Load more users (pagination)
    func loadMoreUsers() async {
        guard hasMorePages, !isLoadingMore else { return }

        logger.info("Loading more users at offset: \(self.currentOffset)")
        isLoadingMore = true

        do {
            let response = try await apiClient.fetchUsers()

            self.allUsers.append(contentsOf: response.data)
            state = .loaded(self.allUsers)
            currentOffset += response.data.count
            hasMorePages = response.data.count >= pageSize

            logger.info("Loaded \(response.data.count) more users, total: \(self.allUsers.count)")
        } catch {
            logger.error("Failed to load more users: \(error.localizedDescription)")
        }

        isLoadingMore = false
    }

    /// Refresh users list
    func refresh() async {
        logger.info("Refreshing users")
        HapticFeedback.light()
        await loadUsers()
    }

    /// Update search text
    func updateSearch(_ text: String) {
        searchText = text
        if !text.isEmpty {
            HapticFeedback.selection()
        }
    }

    /// Clear search
    func clearSearch() {
        searchText = ""
    }
}
