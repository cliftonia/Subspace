import SwiftUI
import Testing
@testable import LCARSComponents

@Suite("LCARS Elbow Geometry")
struct LCARSElbowTests {
    private let rect = CGRect(x: 0, y: 0, width: 200, height: 120)

    private func makeElbow(corner: LCARSElbow.Corner = .topLeading) -> LCARSElbow {
        LCARSElbow(corner: corner, armWidth: 80, railHeight: 16, outerRadius: 40, innerRadius: 20)
    }

    @Test
    func `Fills the arm and the rail`() {
        let path = makeElbow().path(in: rect)

        #expect(path.contains(CGPoint(x: 40, y: 110)))
        #expect(path.contains(CGPoint(x: 190, y: 8)))
    }

    @Test
    func `Leaves the area right of the arm and below the rail empty`() {
        let path = makeElbow().path(in: rect)

        #expect(!path.contains(CGPoint(x: 150, y: 80)))
    }

    @Test
    func `Curves the inner bend instead of leaving a square notch`() {
        let path = makeElbow().path(in: rect)

        #expect(path.contains(CGPoint(x: 83, y: 19)))
    }

    @Test
    func `Rounds the outer bend`() {
        let path = makeElbow().path(in: rect)

        #expect(!path.contains(CGPoint(x: 2, y: 2)))
    }

    @Test(arguments: [
        (LCARSElbow.Corner.topTrailing, CGPoint(x: 198, y: 2)),
        (LCARSElbow.Corner.bottomLeading, CGPoint(x: 2, y: 118)),
        (LCARSElbow.Corner.bottomTrailing, CGPoint(x: 198, y: 118))
    ])
    func `Mirrors the outer bend into each corner`(corner: LCARSElbow.Corner, outerTip: CGPoint) {
        let path = makeElbow(corner: corner).path(in: rect)

        #expect(!path.contains(outerTip))
    }

    @Test
    func `Respects the origin of the rect`() {
        let offsetRect = rect.offsetBy(dx: 50, dy: 30)

        let path = makeElbow(corner: .bottomTrailing).path(in: offsetRect)

        #expect(path.boundingRect == offsetRect)
    }

    @Test
    func `Stays within rects smaller than its dimensions`() {
        let tiny = CGRect(x: 0, y: 0, width: 30, height: 10)

        let path = makeElbow().path(in: tiny)

        #expect(path.boundingRect.width <= tiny.width)
        #expect(path.boundingRect.height <= tiny.height)
    }

    @Test
    func `Draws nothing in an empty rect`() {
        #expect(makeElbow().path(in: .zero).isEmpty)
    }
}

@Suite("LCARS Stable Codes")
struct LCARSCodeTests {
    @Test
    func `The same seed always produces the same digits`() {
        #expect(LCARSUtilities.stableDigits("HOME", count: 6) == LCARSUtilities.stableDigits("HOME", count: 6))
    }

    @Test
    func `Different seeds produce different digits`() {
        #expect(LCARSUtilities.stableDigits("HOME", count: 6) != LCARSUtilities.stableDigits("CREW", count: 6))
    }

    @Test(arguments: [1, 4, 12])
    func `Produces the requested number of decimal digits`(count: Int) {
        let digits = LCARSUtilities.stableDigits("SENSORS", count: count)

        #expect(digits.count == count)
        let allNumeric = digits.allSatisfy { $0.isNumber }
        #expect(allNumeric)
    }
}

@Suite("LCARS Weighted Layout")
struct LCARSWeightedRowTests {
    @Test
    func `Shares the width in proportion to the weights after gaps`() {
        let widths = LCARSWeightedRow.widths(for: [1, 3], available: 104, spacing: 4)

        #expect(widths == [25, 75])
    }

    @Test
    func `Handles an empty row`() {
        #expect(LCARSWeightedRow.widths(for: [], available: 100, spacing: 4).isEmpty)
    }

    @Test
    func `Never produces a negative width`() {
        let widths = LCARSWeightedRow.widths(for: [1, 1], available: 2, spacing: 4)

        #expect(widths == [0, 0])
    }
}

@Suite("LCARS Fonts")
struct LCARSFontTests {
    @Test
    func `Ships both bundled fonts`() {
        #expect(LCARSFonts.bundledFontURLs.count == 2)
    }

    @Test
    func `Ships every interface sound`() {
        for sound in LCARSAudio.Sound.allCases {
            #expect(LCARSAudio.hasResource(for: sound))
        }
    }

    @Test(arguments: LCARSAudio.Sound.allCases)
    func `Every interface sound decodes to audible signal`(sound: LCARSAudio.Sound) throws {
        #expect(try LCARSAudio.peakLevel(of: sound) > 0.05)
    }
}
