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

    @Environment(AuthViewModel.self) private var authViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var isPasswordVisible = false
    @State private var agreedToTerms = false
    @FocusState private var focusedField: Field?

    // MARK: - Field Enum

    private enum Field: Hashable {
        case name
        case email
        case password
        case confirmPassword
    }

    // MARK: - Body

    var body: some View {
        GeometryReader { _ in
            ZStack {
                Color.lcarBlack
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 24) {
                        LCARSHeader(
                            "PERSONNEL REGISTRATION",
                            subtitle: "New Account Creation",
                            code: "LCARS 90176"
                        )
                        .padding(.top, 32)
                        .padding(.horizontal, 32)

                        // Form
                        VStack(spacing: 16) {
                            LCARSTextField(
                                placeholder: "FULL NAME",
                                text: $name,
                                icon: "person.fill"
                            )
                            .focused($focusedField, equals: .name)

                            LCARSTextField(
                                placeholder: "PERSONNEL ID",
                                text: $email,
                                icon: "envelope.fill"
                            )
                            .focused($focusedField, equals: .email)
                            .textInputAutocapitalization(.never)
                            .keyboardType(.emailAddress)

                            LCARSTextField(
                                placeholder: "PASSWORD",
                                text: $password,
                                icon: "lock.fill",
                                isSecure: !isPasswordVisible,
                                showVisibilityToggle: true,
                                isPasswordVisible: $isPasswordVisible
                            )
                            .focused($focusedField, equals: .password)

                            LCARSTextField(
                                placeholder: "CONFIRM PASSWORD",
                                text: $confirmPassword,
                                icon: "lock.fill",
                                isSecure: !isPasswordVisible,
                                showVisibilityToggle: true,
                                isPasswordVisible: $isPasswordVisible
                            )
                            .focused($focusedField, equals: .confirmPassword)

                            // Password requirements
                            if !password.isEmpty {
                                passwordRequirements
                            }

                            // Terms checkbox
                            termsCheckbox
                        }
                        .padding(.horizontal, 32)

                        // Signup button
                        LCARSButton(
                            "CREATE ACCOUNT",
                            code: LCARSUtilities.randomDigits(4),
                            color: .lcarOrange
                        ) {
                            handleSignup()
                        }
                        .disabled(authViewModel.isProcessing || !isFormValid)
                        .opacity(isFormValid ? 1.0 : 0.5)
                        .padding(.horizontal, 32)

                        // Cancel button
                        Button(action: { dismiss() }) {
                            HStack(spacing: 8) {
                                Image(systemName: "arrow.left")
                                Text("RETURN TO LOGIN")
                                    .font(.custom("HelveticaNeue-CondensedBold", size: 14))
                            }
                            .foregroundStyle(Color.lcarTan)
                        }
                        .padding(.top, 16)

                        Spacer(minLength: 40)
                    }
                }
            }
        }
        .onTapGesture {
            focusedField = nil
        }
    }

    // MARK: - Subviews

    private var passwordRequirements: some View {
        VStack(alignment: .leading, spacing: 6) {
            requirementRow("6+ characters", met: password.count >= 6)
            requirementRow("Passwords match", met: !confirmPassword.isEmpty && password == confirmPassword)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(Color.lcarViolet.opacity(0.5), lineWidth: 1)
        )
    }

    private func requirementRow(_ text: String, met: Bool) -> some View {
        HStack(spacing: 8) {
            Image(systemName: met ? "checkmark.circle.fill" : "circle")
                .foregroundStyle(met ? Color.lcarOrange : Color.lcarWhite.opacity(0.3))
                .font(.system(size: 14))

            Text(text)
                .font(.custom("HelveticaNeue-CondensedBold", size: 12))
                .foregroundStyle(met ? Color.lcarWhite : Color.lcarWhite.opacity(0.6))
        }
    }

    private var termsCheckbox: some View {
        Button(action: { agreedToTerms.toggle() }) {
            HStack(spacing: 12) {
                Image(systemName: agreedToTerms ? "checkmark.square.fill" : "square")
                    .foregroundStyle(agreedToTerms ? Color.lcarOrange : Color.lcarWhite)
                    .font(.system(size: 20))

                Text("I agree to the Service Terms and Data Protocols")
                    .font(.custom("HelveticaNeue-CondensedBold", size: 12))
                    .foregroundStyle(Color.lcarWhite)
                    .multilineTextAlignment(.leading)

                Spacer()
            }
        }
    }

    // MARK: - Computed Properties

    private var isFormValid: Bool {
        !name.isEmpty &&
            !email.isEmpty &&
            password.count >= 6 &&
            password == confirmPassword &&
            agreedToTerms
    }

    // MARK: - Methods

    private func handleSignup() {
        guard isFormValid else { return }

        focusedField = nil
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
