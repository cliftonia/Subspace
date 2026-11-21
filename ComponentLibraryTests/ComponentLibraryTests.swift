//
//  ComponentLibraryTests.swift
//  ComponentLibraryTests
//
//  Created by Clifton Baggerman on 04/10/2025.
//

import Foundation
import Testing
@testable import ComponentLibrary

/// The sound manager skips any sound whose file is missing, so a renamed or deleted file fails silently in the app.
struct LCARSSoundBundleTests {

    @Test(arguments: LCARSSoundManager.LCARSSound.allCases)
    func `every sound ships an mp3 in the app bundle`(sound: LCARSSoundManager.LCARSSound) {
        #expect(Bundle.main.url(forResource: sound.rawValue, withExtension: "mp3") != nil)
    }

    @Test func `every bundled mp3 can be played from the showcase`() throws {
        let urls = try #require(Bundle.main.urls(forResourcesWithExtension: "mp3", subdirectory: nil))
        let bundledNames = Set(urls.map { $0.deletingPathExtension().lastPathComponent })
        let playableNames = Set(LCARSSoundManager.LCARSSound.allCases.map(\.rawValue))

        #expect(!bundledNames.isEmpty)
        #expect(bundledNames.subtracting(playableNames).isEmpty)
    }
}
