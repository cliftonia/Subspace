//
//  MessageSkeletonRow.swift
//  Subspace
//
//  Created by Clifton Baggerman on 25/10/2025.
//

import LCARSComponents
import SwiftUI

/// Loading placeholder shaped like a message row
struct MessageSkeletonRow: View {
    var body: some View {
        HStack(spacing: 8) {
            UnevenRoundedRectangle(topLeadingRadius: 12, bottomLeadingRadius: 12)
                .fill(Color.lcarViolet.opacity(0.3))
                .frame(width: 14, height: 60)

            VStack(alignment: .leading, spacing: 8) {
                Color.lcarViolet.opacity(0.25)
                    .frame(width: 90, height: 12)

                Color.lcarWhite.opacity(0.12)
                    .frame(height: 12)
            }
        }
        .accessibilityHidden(true)
    }
}
