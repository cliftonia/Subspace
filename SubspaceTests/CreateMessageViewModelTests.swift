//
//  CreateMessageViewModelTests.swift
//  Subspace
//
//  Created by Clifton Baggerman on 04/10/2025.
//

import Testing
@testable import Subspace

@Suite("Create Message ViewModel Tests")
struct CreateMessageViewModelTests {

    @Test("Initial state has empty content")
    @MainActor
    func initialStateHasEmptyContent() {
        // Given/When
        let viewModel = CreateMessageViewModel()

        // Then
        #expect(viewModel.content.isEmpty)
        #expect(viewModel.selectedKind == .info)
        #expect(viewModel.isSending == false)
    }

    @Test("Can submit returns false for empty content")
    @MainActor
    func canSubmitReturnsFalseForEmptyContent() {
        // Given
        let viewModel = CreateMessageViewModel()

        // When
        viewModel.content = ""

        // Then
        #expect(viewModel.canSubmit == false)
    }

    @Test("Can submit returns false for whitespace content")
    @MainActor
    func canSubmitReturnsFalseForWhitespaceContent() {
        // Given
        let viewModel = CreateMessageViewModel()

        // When
        viewModel.content = "   \n  \t  "

        // Then
        #expect(viewModel.canSubmit == false)
    }

    @Test("Can submit returns true for valid content")
    @MainActor
    func canSubmitReturnsTrueForValidContent() {
        // Given
        let viewModel = CreateMessageViewModel()

        // When
        viewModel.content = "Valid message content"

        // Then
        #expect(viewModel.canSubmit == true)
    }

    @Test("Selected kind can be changed")
    @MainActor
    func selectedKindCanBeChanged() {
        // Given
        let viewModel = CreateMessageViewModel()

        // When
        viewModel.selectedKind = .warning

        // Then
        #expect(viewModel.selectedKind == .warning)
    }

    @Test("Is sending is false initially")
    @MainActor
    func isSendingIsFalseInitially() {
        // Given/When
        let viewModel = CreateMessageViewModel()

        // Then
        #expect(viewModel.isSending == false)
    }
}
