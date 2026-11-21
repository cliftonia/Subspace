//
//  LCARSSignupView.swift
//  Subspace
//
//  Created by Clifton Baggerman on 04/10/2025.
//

import LCARSComponents
import SwiftUI

/// LCARS-themed signup screen
struct LCARSSignupView: View {
    // MARK: - Properties

    @Environment(AuthViewModel.self)
    private var authViewModel
    @Environment(\.dismiss)
    private var dismiss
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""

    private let header = LCARSConsoleHeader(
        title: "REGISTRATION",
        code: "LCARS \(LCARSUtilities.stableDigits("registration", count: 5))",
        accent: .lcarViolet,
        secondary: .lcarPink,
        railColors: [.lcarViolet, .lcarTan, .lcarOrange, .lcarGold]
    )

    // MARK: - Body

    var body: some View {
        LCARSConsole(header: header) {
            LCARSArmBlocks(seed: "registration")
        } content: {
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    LCARSTextField(placeholder: "FULL NAME", text: $name, color: .lcarViolet)
                        .textContentType(.name)

                    LCARSTextField(placeholder: "PERSONNEL ID", text: $email, color: .lcarViolet)
                        .textContentType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .keyboardType(.emailAddress)

                    LCARSTextField(placeholder: "PASSWORD", text: $password, isSecure: true, color: .lcarViolet)
                        .textContentType(.newPassword)

                    LCARSTextField(placeholder: "CONFIRM PASSWORD", text: $confirmPassword, isSecure: true, color: .lcarViolet)
                        .textContentType(.newPassword)

                    requirementsSection

                    if case .error(let message) = authViewModel.authState {
                        Text(message.uppercased())
                            .font(.lcars(19))
                            .foregroundStyle(Color.lcarRed)
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    Button(authViewModel.isProcessing ? "Registering" : "Create Account", action: handleSignup)
                        .buttonStyle(.lcars(.lcarOrange))
                        .disabled(authViewModel.isProcessing || !isFormValid)

                    Button("Return to Login") {
                        dismiss()
                    }
                    .buttonStyle(.lcars(.lcarTan))
                }
                .padding(.bottom, 16)
            }
            .scrollIndicators(.hidden)
            .scrollDismissesKeyboard(.interactively)
        }
        .presentationBackground(Color.lcarBlack)
        .preferredColorScheme(.dark)
    }

    // MARK: - Subviews

    private var requirementsSection: some View {
        VStack(alignment: .leading, spacing: 2) {
            requirementRow("6+ characters", met: password.count >= 6)
            requirementRow("Passwords match", met: !confirmPassword.isEmpty && password == confirmPassword)
        }
    }

    private func requirementRow(_ text: String, met: Bool) -> some View {
        HStack(spacing: 8) {
            Capsule()
                .fill(met ? Color.lcarOrange : Color.lcarWhite.opacity(0.25))
                .frame(width: 22, height: 10)
                .accessibilityHidden(true)

            Text(text.uppercased())
                .font(.lcars(17))
                .foregroundStyle(met ? Color.lcarWhite : Color.lcarWhite.opacity(0.6))
        }
        .accessibilityValue(met ? "Met" : "Not met")
    }

    // MARK: - Computed Properties

    private var isFormValid: Bool {
        !name.isEmpty &&
            !email.isEmpty &&
            password.count >= 6 &&
            password == confirmPassword
    }

    // MARK: - Methods

    private func handleSignup() {
        guard isFormValid else {
            return
        }

        HapticFeedback.light()

        Task {
            await authViewModel.signup(name: name, email: email, password: password)
            if authViewModel.isAuthenticated {
                dismiss()
            }
        }
    }
}

#Preview {
    LCARSSignupView()
        .environment(AuthViewModel(authService: MockAuthService()))
}
