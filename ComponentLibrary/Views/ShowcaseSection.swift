//
//  ShowcaseSection.swift
//  ComponentLibrary
//
//  Created by Clifton Baggerman on 04/10/2025.
//

import SwiftUI
import LCARSComponents

/// Reusable section container for showcase views
struct ShowcaseSection<Content: View>: View {
    let title: String
    let content: Content

    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.custom("HelveticaNeue-CondensedBold", size: 18))
                .foregroundStyle(Color.lcarWhite)

            content
        }
    }
}
