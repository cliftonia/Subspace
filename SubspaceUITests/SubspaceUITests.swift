//
//  SubspaceUITests.swift
//  SubspaceUITests
//
//  Created by Clifton Baggerman on 03/10/2025.
//

import XCTest

/// Drives the console end to end. Set SCREENSHOT_DIR to keep a screenshot of each screen.
final class SubspaceUITests: XCTestCase {
    private let sections = ["OPS", "COMMS", "CREW", "SENSORS", "CONFIG"]

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        XCUIDevice.shared.orientation = .portrait
    }

    // MARK: - Tests

    @MainActor
    func testEverySectionOpensFromTheArm() throws {
        let app = launchedApp()
        signInIfNeeded(app)

        for section in sections {
            tapSection(section, in: app)
            capture("portrait-\(section)")
        }
    }

    @MainActor
    func testConsoleWorksInLandscape() throws {
        let app = launchedApp()
        signInIfNeeded(app)

        XCUIDevice.shared.orientation = .landscapeLeft

        for section in sections {
            tapSection(section, in: app)
            capture("landscape-\(section)")
        }
    }

    @MainActor
    func testComposeFitsInLandscape() throws {
        let app = launchedApp()
        signInIfNeeded(app)
        tapSection("COMMS", in: app)

        XCUIDevice.shared.orientation = .landscapeLeft
        app.buttons["New Transmission"].tap()

        XCTAssertTrue(app.buttons["Cancel"].waitForExistence(timeout: 5))
        capture("landscape-compose")
        XCTAssertTrue(app.buttons["Cancel"].isHittable)
        app.buttons["Cancel"].tap()
    }

    @MainActor
    func testConsoleWorksAtTheLargestTextSize() throws {
        let app = launchedApp(arguments: ["-UIPreferredContentSizeCategoryName", "UICTContentSizeCategoryAccessibilityXXXL"])
        signInIfNeeded(app)

        for section in sections {
            tapSection(section, in: app)
            capture("largest-text-\(section)")
        }
    }

    @MainActor
    func testSendingATransmissionAddsItToComms() throws {
        let app = launchedApp()
        signInIfNeeded(app)
        tapSection("COMMS", in: app)

        app.buttons["New Transmission"].tap()
        XCTAssertTrue(app.buttons["H"].waitForExistence(timeout: 5))
        // The keyboard starts in capitals and drops to lower case after the first letter
        for key in ["H", "i"] {
            app.buttons[key].tap()
        }
        capture("compose")
        app.buttons["Send"].tap()

        // The sheet shows the text too, so the message only counts once the sheet has closed
        XCTAssertTrue(app.buttons["Send"].waitForNonExistence(timeout: 5), "The sheet stayed open")
        XCTAssertTrue(app.staticTexts["Hi"].firstMatch.waitForExistence(timeout: 5))
    }

    // MARK: - Helpers

    @MainActor
    private func launchedApp(arguments: [String] = []) -> XCUIApplication {
        let app = XCUIApplication()
        app.launchArguments = arguments
        if let baseURL = ProcessInfo.processInfo.environment["API_BASE_URL"] {
            app.launchEnvironment["API_BASE_URL"] = baseURL
        }
        app.launch()
        return app
    }

    @MainActor
    private func signInIfNeeded(_ app: XCUIApplication) {
        let demo = app.buttons["Demo"]
        let ops = app.buttons["OPS"]
        let orientation = app.buttons["Continue"]
        XCTAssertTrue(waitForAny([demo, ops, orientation]))

        if demo.exists {
            demo.tap()
            XCTAssertTrue(waitForAny([ops, orientation]))
        }

        while !ops.exists {
            let next = orientation.exists ? orientation : app.buttons["Begin"]
            XCTAssertTrue(next.waitForExistence(timeout: 3))
            next.tap()
            _ = ops.waitForExistence(timeout: 1)
        }
    }

    @MainActor
    private func waitForAny(_ elements: [XCUIElement], timeout: TimeInterval = 15) -> Bool {
        let deadline = Date().addingTimeInterval(timeout)
        while Date() < deadline {
            if elements.contains(where: \.exists) {
                return true
            }
            RunLoop.current.run(until: Date().addingTimeInterval(0.2))
        }
        return false
    }

    @MainActor
    private func tapSection(_ section: String, in app: XCUIApplication) {
        let button = app.buttons[section]
        XCTAssertTrue(button.waitForExistence(timeout: 5), "\(section) is missing")

        // The arm scrolls when the window is too short to show every button
        var swipes = 0
        while !button.isHittable && swipes < 4 {
            app.scrollViews.firstMatch.swipeUp()
            swipes += 1
        }

        XCTAssertTrue(button.isHittable, "\(section) cannot be reached")
        button.tap()
        RunLoop.current.run(until: Date().addingTimeInterval(0.8))
    }

    @MainActor
    private func capture(_ name: String) {
        guard let directory = ProcessInfo.processInfo.environment["SCREENSHOT_DIR"] else {
            return
        }
        let url = URL(fileURLWithPath: directory).appendingPathComponent("\(name).png")
        try? XCUIScreen.main.screenshot().pngRepresentation.write(to: url)
    }
}

/// Runs the console against a real server. Requires API_BASE_URL, BACKEND_EMAIL and BACKEND_PASSWORD.
final class SubspaceBackendUITests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testSignInThenBrowseAndSendAgainstTheServer() throws {
        let environment = ProcessInfo.processInfo.environment
        guard let baseURL = environment["API_BASE_URL"],
              let email = environment["BACKEND_EMAIL"],
              let password = environment["BACKEND_PASSWORD"] else {
            throw XCTSkip("Needs API_BASE_URL, BACKEND_EMAIL and BACKEND_PASSWORD")
        }

        let app = XCUIApplication()
        app.launchEnvironment["API_BASE_URL"] = baseURL
        app.launch()

        let ops = app.buttons["OPS"]
        let apple = app.buttons["Apple Identity System"]
        let deadline = Date().addingTimeInterval(15)
        while Date() < deadline && !ops.exists && !apple.exists {
            RunLoop.current.run(until: Date().addingTimeInterval(0.2))
        }

        if apple.exists {
            XCTAssertFalse(app.buttons["Demo"].exists, "Offline sign in should be hidden on a real server")
            app.textFields.firstMatch.tap()
            app.textFields.firstMatch.typeText(email)
            app.secureTextFields.firstMatch.tap()
            app.secureTextFields.firstMatch.typeText(password)
            app.buttons["Authenticate"].tap()
        }

        passOnboarding(in: app)
        XCTAssertTrue(ops.exists, "Sign in did not reach the console")

        app.buttons["CREW"].tap()
        // The server returns one page of users, so check for any row rather than a particular officer
        let crewEmail = app.staticTexts.matching(NSPredicate(format: "label CONTAINS '@'")).firstMatch
        XCTAssertTrue(crewEmail.waitForExistence(timeout: 5), "The crew list did not load")

        app.buttons["COMMS"].tap()
        XCTAssertTrue(app.buttons["New Transmission"].waitForExistence(timeout: 5))
        app.buttons["New Transmission"].tap()
        let keyboardAppeared = app.buttons["H"].waitForExistence(timeout: 5)
        if let directory = environment["SCREENSHOT_DIR"] {
            let url = URL(fileURLWithPath: directory).appendingPathComponent("backend-compose.png")
            try? XCUIScreen.main.screenshot().pngRepresentation.write(to: url)
        }
        XCTAssertTrue(keyboardAppeared, "The compose sheet did not open")
        app.buttons["H"].tap()
        app.buttons["i"].tap()
        app.buttons["Send"].tap()

        // The sheet shows the text too, so the message only counts once the sheet has closed
        XCTAssertTrue(app.buttons["Send"].waitForNonExistence(timeout: 5), "The server refused the message")
        XCTAssertTrue(app.staticTexts["Hi"].firstMatch.waitForExistence(timeout: 5), "The sent message did not appear")
    }

    @MainActor
    func testLogOutThenAppleSignInStartsWithoutCrashing() throws {
        guard let baseURL = ProcessInfo.processInfo.environment["API_BASE_URL"] else {
            throw XCTSkip("Needs API_BASE_URL")
        }

        let app = XCUIApplication()
        app.launchEnvironment["API_BASE_URL"] = baseURL
        app.launch()

        let apple = app.buttons["Apple Identity System"]
        let config = app.buttons["CONFIG"]
        let deadline = Date().addingTimeInterval(15)
        while Date() < deadline && !config.exists && !apple.exists {
            RunLoop.current.run(until: Date().addingTimeInterval(0.2))
        }

        if config.exists {
            config.tap()
            XCTAssertTrue(app.buttons["Log Out"].waitForExistence(timeout: 5))
            app.buttons["Log Out"].tap()
        }

        XCTAssertTrue(apple.waitForExistence(timeout: 10), "Logging out did not return to the login screen")
        apple.tap()
        RunLoop.current.run(until: Date().addingTimeInterval(4))

        if let directory = ProcessInfo.processInfo.environment["SCREENSHOT_DIR"] {
            let url = URL(fileURLWithPath: directory).appendingPathComponent("apple-sign-in.png")
            try? XCUIScreen.main.screenshot().pngRepresentation.write(to: url)
        }
        XCTAssertEqual(app.state, .runningForeground)
    }

    @MainActor
    private func passOnboarding(in app: XCUIApplication) {
        let deadline = Date().addingTimeInterval(15)
        while Date() < deadline && !app.buttons["OPS"].exists {
            if app.buttons["Continue"].exists {
                app.buttons["Continue"].tap()
            } else if app.buttons["Begin"].exists {
                app.buttons["Begin"].tap()
            }
            RunLoop.current.run(until: Date().addingTimeInterval(0.5))
        }
    }
}
