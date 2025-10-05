//
//  LCARSLoginView.swift
//  Subspace
//
//  Created by Clifton Baggerman on 04/10/2025.
//

import SwiftUI

/// LCARS-themed login screen with Star Trek styling
struct LCARSLoginView: View {

    // MARK: - Properties

    @Environment(AuthViewModel.self) private var authViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var isPasswordVisible = false
    @State private var showSignup = false
    @State private var showDemoHint = true
    @FocusState private var focusedField: Field?

    // MARK: - Field Enum

    private enum Field: Hashable {
        case email
        case password
    }

    // MARK: - Body

    var body: some View {
        GeometryReader { geo in
            ZStack {
                // Black background
                Color.lcarBlack
                    .ignoresSafeArea()

                // Main content area
                ScrollView {
                        VStack(spacing: 24) {
                            // Header
                            LCARSHeader(
                                "SECURITY ACCESS",
                                subtitle: "Authentication Required",
                                code: "LCARS 47594"
                            )
                            .padding(.top, 40)
                            .padding(.horizontal, 32)

                            // Demo credentials hint
                            if showDemoHint {
                                demoHintView
                                    .padding(.horizontal, 32)
                            }

                            // Login form
                            VStack(spacing: 16) {
                                LCARSTextField(
                                    placeholder: "PERSONNEL ID",
                                    text: $email,
                                    icon: "person.fill"
                                )
                                .focused($focusedField, equals: .email)
                                .textContentType(.emailAddress)
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
                                .textContentType(.password)
                            }
                            .padding(.horizontal, 32)

                            // Login button
                            LCARSButton(
                                "AUTHENTICATE",
                                code: LCARSUtilities.randomDigits(4),
                                color: .lcarOrange
                            ) {
                                handleLogin()
                            }
                            .disabled(authViewModel.isProcessing || !isFormValid)
                            .opacity(isFormValid ? 1.0 : 0.5)
                            .padding(.horizontal, 32)

                            // Divider
                            HStack(spacing: 8) {
                                LCARSPanel(color: .lcarViolet, height: 2, cornerRadius: 1)
                                Text("ALTERNATE ACCESS")
                                    .font(.custom("HelveticaNeue-CondensedBold", size: 12))
                                    .foregroundStyle(Color.lcarOrange)
                                LCARSPanel(color: .lcarViolet, height: 2, cornerRadius: 1)
                            }
                            .padding(.horizontal, 32)
                            .padding(.top, 16)

                            // Social login
                            VStack(spacing: 12) {
                                LCARSButton(
                                    "APPLE IDENTITY SYSTEM",
                                    code: "AAPL",
                                    color: .lcarViolet
                                ) {
                                    handleAppleSignIn()
                                }

                                LCARSButton(
                                    "GOOGLE FEDERATION",
                                    code: "GOOG",
                                    color: .lcarPlum
                                ) {
                                    handleGoogleSignIn()
                                }
                            }
                            .padding(.horizontal, 32)

                            // Signup link
                            Button(action: { showSignup = true }) {
                                HStack(spacing: 8) {
                                    Text("NEW PERSONNEL")
                                        .font(.custom("HelveticaNeue-CondensedBold", size: 14))
                                    Image(systemName: "arrow.right")
                                }
                                .foregroundStyle(Color.lcarTan)
                            }
                            .padding(.top, 24)

                            Spacer(minLength: 40)
                        }
                    }
            }
        }
        .onTapGesture {
            focusedField = nil
        }
        .sheet(isPresented: $showSignup) {
            LCARSSignupView()
        }
    }

    // MARK: - Subviews

    private var demoHintView: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "info.circle.fill")
                    .foregroundStyle(Color.lcarBlue)
                Text("DEMO CREDENTIALS")
                    .font(.custom("HelveticaNeue-CondensedBold", size: 14))
                    .foregroundStyle(Color.lcarBlue)
                Spacer()
                Button(action: { showDemoHint = false }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(Color.lcarOrange)
                }
            }

            VStack(alignment: .leading, spacing: 4) {
                Text("ID: demo@example.com")
                    .font(.custom("Menlo", size: 12))
                    .foregroundStyle(Color.lcarWhite)
                Text("PASSWORD: password")
                    .font(.custom("Menlo", size: 12))
                    .foregroundStyle(Color.lcarWhite)
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.lcarBlue.opacity(0.2))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .strokeBorder(Color.lcarBlue, lineWidth: 1)
                )
        )
    }

    // MARK: - Computed Properties

    private var isFormValid: Bool {
        !email.isEmpty && !password.isEmpty
    }

    // MARK: - Methods

    private func handleLogin() {
        guard isFormValid else { return }

        focusedField = nil
        HapticFeedback.light()

        Task {
            await authViewModel.login(email: email, password: password)
        }
    }

    private func handleAppleSignIn() {
        HapticFeedback.light()
        Task {
            await authViewModel.signInWithApple()
        }
    }

    private func handleGoogleSignIn() {
        HapticFeedback.light()
        Task {
            await authViewModel.signInWithGoogle()
        }
    }
}

#Preview {
    LCARSLoginView()
        .environment(AuthViewModel(authService: MockAuthService()))
}
