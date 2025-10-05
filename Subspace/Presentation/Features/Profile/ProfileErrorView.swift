//
//  ProfileErrorView.swift
//  Subspace
//
//  Created by Clifton Baggerman on 06/10/2025.
//

import SwiftUI
import LCARSComponents

/// Error state view for profile
struct ProfileErrorView: View {

    // MARK: - Properties

    let message: String

    // MARK: - Body

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 40))
                .foregroundStyle(Color.lcarPlum)

            Text("ERROR")
                .font(.custom("HelveticaNeue-CondensedBold", size: 16))
                .foregroundStyle(Color.lcarPlum)

            Text(message)
                .font(.custom("HelveticaNeue", size: 12))
                .foregroundStyle(Color.lcarWhite.opacity(0.7))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
        }
    }
}
