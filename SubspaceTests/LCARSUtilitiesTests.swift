//
//  LCARSUtilitiesTests.swift
//  Subspace
//
//  Created by Clifton Baggerman on 04/10/2025.
//

import Testing
@testable import Subspace

@Suite("LCARS Utilities Tests")
struct LCARSUtilitiesTests {

    @Test("Random digits generates correct length")
    func randomDigitsGeneratesCorrectLength() {
        // Given
        let count = 5

        // When
        let result = LCARSUtilities.randomDigits(count)

        // Then
        #expect(result.count == count)
    }

    @Test("Random digits contains only numeric characters")
    func randomDigitsContainsOnlyNumericCharacters() {
        // Given
        let count = 10

        // When
        let result = LCARSUtilities.randomDigits(count)

        // Then
        #expect(result.allSatisfy { $0.isNumber })
    }

    @Test("LCAR code has correct format")
    func lcarCodeHasCorrectFormat() {
        // Given
        let prefix = "TEST"
        let digits = 6

        // When
        let result = LCARSUtilities.lcarCode(prefix: prefix, digits: digits)

        // Then
        #expect(result.hasPrefix(prefix))
        #expect(result.contains(" "))

        let components = result.split(separator: " ")
        #expect(components.count == 2)
        #expect(components[1].count == digits)
    }

    @Test("System code has correct format")
    func systemCodeHasCorrectFormat() {
        // Given
        let section = "03"
        let digits = 6

        // When
        let result = LCARSUtilities.systemCode(section: section, digits: digits)

        // Then
        #expect(result.hasPrefix(section))
        #expect(result.contains("-"))

        let components = result.split(separator: "-")
        #expect(components.count == 2)
        #expect(components[1].count == digits)
    }

    @Test("Different calls generate different values")
    func differentCallsGenerateDifferentValues() {
        // Given
        let count = 10

        // When
        let result1 = LCARSUtilities.randomDigits(count)
        let result2 = LCARSUtilities.randomDigits(count)
        let result3 = LCARSUtilities.randomDigits(count)

        // Then - At least one should be different (statistically very likely)
        #expect(!(result1 == result2 && result2 == result3))
    }
}
