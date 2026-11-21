//
//  ComponentLibraryApp.swift
//  ComponentLibrary
//
//  Created by Clifton Baggerman on 04/10/2025.
//

import LCARSComponents
import SwiftUI

@main
struct ComponentLibraryApp: App {
    init() {
        LCARSFonts.register()
    }

    var body: some Scene {
        WindowGroup {
            ComponentShowcaseView()
                .preferredColorScheme(.dark)
                .statusBarHidden()
        }
    }
}
