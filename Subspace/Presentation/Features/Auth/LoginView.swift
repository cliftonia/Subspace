//
//  LCARSLoginView.swift
//  Subspace
//
//  Created by Clifton Baggerman on 04/10/2025.
//

import LCARSComponents
import os
import SwiftUI

/// LCARS-themed login screen with Star Trek styling
struct LCARSLoginView: View {
    // MARK: - Types

    private struct CrewLogin: Identifiable {
        let title: String
        let email: String
        let password: String

        var id: String { email }
    }

    // MARK: - Properties

    @Environment(AuthViewModel.self)
    private var authViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var showSignup = false
    @FocusState private var isEntryFocused: Bool

    private let logger = Logger.app(category: "LoginView")

    private let header = LCARSConsoleHeader(
        title: "SECURITY ACCESS",
        code: "LCARS \(LCARSUtilities.stableDigits("security", count: 5))",
        accent: .lcarOrange,
        secondary: .lcarPink,
        railColors: [.lcarOrange, .lcarTan, .lcarViolet, .lcarGold]
    )

    private let crewLogins = [
        CrewLogin(title: "Picard", email: "picard@starfleet.com", password: "engage"),
        CrewLogin(title: "Riker", email: "riker@starfleet.com", password: "number1"),
        CrewLogin(title: "Demo", email: "demo@example.com", password: "password")
    ]

    // MARK: - Body

    var body: some View {
        LCARSConsole(header: header) {
            LCARSArmBlocks(seed: "security")
        } content: {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    credentialsSection

                    if AppConfiguration.usesLocalFleet {
                        crewAccessSection
                    } else {
                        alternateAccessSection
                    }

                    Button("New Personnel") {
                        showSignup = true
                    }
                    .buttonStyle(.lcars(.lcarTan))
                }
                .padding(.bottom, 16)
            }
            .scrollIndicators(.hidden)
            .scrollDismissesKeyboard(.interactively)
        }
        .sheet(isPresented: $showSignup) {
            LCARSSignupView()
        }
    }

    // MARK: - Sections

    private var credentialsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("AUTHENTICATION REQUIRED")
                .font(.lcars(22))
                .foregroundStyle(Color.lcarOrange)

            LCARSTextField(placeholder: "PERSONNEL ID", text: $email)
                .focused($isEntryFocused)
                .textContentType(.emailAddress)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .keyboardType(.emailAddress)

            LCARSTextField(placeholder: "PASSWORD", text: $password, isSecure: true)
                .focused($isEntryFocused)
                .textContentType(.password)

            if case .error(let message) = authViewModel.authState {
                Text(message.uppercased())
                    .font(.lcars(19))
                    .foregroundStyle(Color.lcarRed)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Button(authViewModel.isProcessing ? "Verifying" : "Authenticate", action: handleLogin)
                .buttonStyle(.lcars(.lcarOrange))
                .disabled(authViewModel.isProcessing || !isFormValid)
        }
    }

    private var crewAccessSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            LCARSSectionHeader("Crew Access", color: .lcarViolet)

            HStack(spacing: LCARSMetrics.gutter) {
                ForEach(crewLogins) { login in
                    Button(login.title) {
                        email = login.email
                        password = login.password
                        handleLogin()
                    }
                    .buttonStyle(.lcars(.lcarViolet, form: .segment))
                }
            }
        }
    }

    private var alternateAccessSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            LCARSSectionHeader("Alternate Access", color: .lcarViolet)

            Button("Apple Identity System") {
                Task {
                    logger.info("Starting Apple Sign-In flow")
                    await authViewModel.signInWithApple()
                }
            }
            .buttonStyle(.lcars(.lcarViolet))
        }
    }

    // MARK: - Computed Properties

    private var isFormValid: Bool {
        !email.isEmpty && !password.isEmpty
    }

    // MARK: - Methods

    private func handleLogin() {
        guard isFormValid else {
            return
        }

        isEntryFocused = false
        HapticFeedback.light()

        Task {
            await authViewModel.login(email: email, password: password)
        }
    }
}

#Preview {
    LCARSLoginView()
        .environment(AuthViewModel(authService: MockAuthService()))
}
