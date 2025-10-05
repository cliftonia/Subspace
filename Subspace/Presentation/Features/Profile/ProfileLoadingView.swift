//
//  ProfileLoadingView.swift
//  Subspace
//
//  Created by Clifton Baggerman on 06/10/2025.
//

import SwiftUI
import LCARSComponents

/// Loading state view for profile
struct ProfileLoadingView: View {

    var body: some View {
        VStack(spacing: 16) {
            Circle()
                .fill(Color.lcarWhite.opacity(0.2))
                .frame(width: 80, height: 80)

            RoundedRectangle(cornerRadius: 4)
                .fill(Color.lcarWhite.opacity(0.2))
                .frame(width: 150, height: 20)

            VStack(spacing: 8) {
                ForEach(0..<3, id: \.self) { _ in
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.lcarWhite.opacity(0.1))
                        .frame(width: 250, height: 40)
                }
            }
        }
    }
}
