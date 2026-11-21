//
//  ProfileErrorView.swift
//  Subspace
//
//  Created by Clifton Baggerman on 06/10/2025.
//

import LCARSComponents
import SwiftUI

/// Shown when a personnel file cannot be retrieved
struct ProfileErrorView: View {
    let message: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("RECORD UNAVAILABLE")
                .font(.lcars(24))
                .foregroundStyle(Color.lcarRed)

            Text(message)
                .font(.lcarsBody(16))
                .foregroundStyle(Color.lcarWhite.opacity(0.7))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
