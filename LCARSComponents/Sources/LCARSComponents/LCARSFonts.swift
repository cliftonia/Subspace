//
//  LCARSFonts.swift
//  LCARSComponents
//
//  Created by Clifton Baggerman on 30/10/2026.
//

import CoreText
import SwiftUI

/// Registers the typefaces bundled with this package
public enum LCARSFonts {
    static let bundledFontURLs: [URL] = ["LCARSGTJ3", "Antonio"].compactMap {
        Bundle.module.url(forResource: $0, withExtension: "ttf")
    }

    private static let registration: Void = {
        for url in bundledFontURLs {
            CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
        }
    }()

    /// Makes the fonts available to this process. Safe to call more than once.
    public static func register() {
        registration
    }
}

public extension Font {
    /// Ultra-condensed LCARS display type for labels, titles and readouts
    static func lcars(_ size: CGFloat, relativeTo style: Font.TextStyle = .body) -> Font {
        .custom("LCARSGTJ3", size: size, relativeTo: style)
    }

    /// Condensed mixed-case type for sentences that must stay easy to read
    static func lcarsBody(_ size: CGFloat, relativeTo style: Font.TextStyle = .body) -> Font {
        .custom("Antonio", size: size, relativeTo: style)
    }
}
