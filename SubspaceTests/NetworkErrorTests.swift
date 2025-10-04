//
//  NetworkErrorTests.swift
//  Subspace
//
//  Created by Clifton Baggerman on 04/10/2025.
//

import Testing
@testable import Subspace

@Suite("Network Error Tests")
struct NetworkErrorTests {

    @Test("No connection error has correct description")
    func noConnectionErrorHasCorrectDescription() {
        // Given
        let error = NetworkError.noConnection

        // Then
        #expect(error.errorDescription == "No internet connection")
        #expect(error.failureReason == "Please check your network settings and try again")
    }

    @Test("Timeout error has correct description")
    func timeoutErrorHasCorrectDescription() {
        // Given
        let error = NetworkError.timeout

        // Then
        #expect(error.errorDescription == "Request timed out")
        #expect(error.failureReason == "The server took too long to respond")
    }

    @Test("Server error includes status code")
    func serverErrorIncludesStatusCode() {
        // Given
        let statusCode = 500
        let error = NetworkError.serverError(code: statusCode)

        // Then
        #expect(error.errorDescription == "Server error (500)")
        #expect(error.failureReason == "The server encountered an error")
    }

    @Test("Invalid response error has correct description")
    func invalidResponseErrorHasCorrectDescription() {
        // Given
        let error = NetworkError.invalidResponse

        // Then
        #expect(error.errorDescription == "Invalid response")
        #expect(error.failureReason == "The server returned an invalid response")
    }

    @Test("Decoding failed error has correct description")
    func decodingFailedErrorHasCorrectDescription() {
        // Given
        let error = NetworkError.decodingFailed

        // Then
        #expect(error.errorDescription == "Failed to decode response")
        #expect(error.failureReason == "The response data was in an unexpected format")
    }

    @Test("Unknown error has correct description")
    func unknownErrorHasCorrectDescription() {
        // Given
        let error = NetworkError.unknown

        // Then
        #expect(error.errorDescription == "An unknown error occurred")
        #expect(error.failureReason == "Please try again later")
    }

    @Test("Server errors with different codes are not equal")
    func serverErrorsWithDifferentCodesAreNotEqual() {
        // Given
        let error1 = NetworkError.serverError(code: 500)
        let error2 = NetworkError.serverError(code: 503)

        // Then
        #expect(error1 != error2)
    }

    @Test("Same error types are equal")
    func sameErrorTypesAreEqual() {
        // Given
        let error1 = NetworkError.noConnection
        let error2 = NetworkError.noConnection

        // Then
        #expect(error1 == error2)
    }
}
