//
//  ProfileViewModel.swift
//  Subspace
//
//  Created by Clifton Baggerman on 03/10/2025.
//

import SwiftUI
import Observation
import os

// MARK: - Profile State

enum ProfileState: Equatable {
    case idle
    case loading
    case loaded(User)
    case error(String)

    static func == (lhs: ProfileState, rhs: ProfileState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle):
            return true
        case (.loading, .loading):
            return true
        case (.loaded(let lhsUser), .loaded(let rhsUser)):
            return lhsUser.id == rhsUser.id
        case (.error(let lhsMessage), .error(let rhsMessage)):
            return lhsMessage == rhsMessage
        default:
            return false
        }
    }
}

// MARK: - Profile View Model

/// ViewModel for profile screen following MVVM architecture
@MainActor
@Observable
final class ProfileViewModel {

    // MARK: - Properties

    private(set) var state: ProfileState = .idle
    private(set) var isInteractionEnabled = true
    
    // MARK: - Private Properties
    
    private let logger = Logger.app(category: "ProfileViewModel")
    private var userService: UserServiceProtocol?
    private var currentUserId: String?
    
    // MARK: - Public Methods
    
    /// Load user profile
    /// - Parameters:
    ///   - userId: The user ID to load
    ///   - userService: Service to fetch user data
    func loadProfile(userId: String, userService: UserServiceProtocol) async {
        self.userService = userService
        self.currentUserId = userId
        
        await loadUserData(userId: userId)
    }
    
    /// Refresh profile data
    func refresh() async {
        guard let userService = userService,
              let userId = currentUserId else {
            logger.error("Cannot refresh: missing dependencies")
            HapticFeedback.error()
            return
        }

        logger.info("Refreshing profile data")
        HapticFeedback.light()
        await loadProfile(userId: userId, userService: userService)
    }
    
    // MARK: - Private Methods
    
    private func loadUserData(userId: String) async {
        guard let userService = userService else {
            logger.error("UserService not available")
            state = .error("Service unavailable")
            return
        }
        
        logger.info("Loading profile for user: \(userId)")
        
        state = .loading
        isInteractionEnabled = false
        
        do {
            let user = try await userService.fetchUser(id: userId)
            state = .loaded(user)
            HapticFeedback.success()
            logger.info("Profile loaded successfully for: \(user.name)")
        } catch let error as NetworkError {
            logger.error("Failed to load profile: \(error)")
            state = .error(error.localizedDescription)
            HapticFeedback.error()
        } catch {
            logger.error("Failed to load profile: \(error)")
            state = .error("Failed to load profile")
            HapticFeedback.error()
        }

        isInteractionEnabled = true
    }
}