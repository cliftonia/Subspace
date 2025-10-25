//
//  MessageSkeletonRow.swift
//  Subspace
//
//  Created by Clifton Baggerman on 25/10/2025.
//

import SwiftUI

/// Skeleton loading placeholder for message rows
struct MessageSkeletonRow: View {
    var body: some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.lcarViolet.opacity(0.3))
                .frame(width: 60, height: 60)

            VStack(alignment: .leading, spacing: 6) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.lcarWhite.opacity(0.2))
                    .frame(width: 120, height: 12)

                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.lcarWhite.opacity(0.1))
                    .frame(height: 10)

                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.lcarWhite.opacity(0.1))
                    .frame(width: 180, height: 10)
            }

            Spacer()
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(Color.lcarWhite.opacity(0.2), lineWidth: 1)
        )
    }
}

// MARK: - Preview

#Preview {
    MessageSkeletonRow()
        .background(Color.lcarBlack)
}
