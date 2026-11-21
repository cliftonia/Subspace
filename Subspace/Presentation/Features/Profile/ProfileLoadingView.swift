//
//  ProfileLoadingView.swift
//  Subspace
//
//  Created by Clifton Baggerman on 06/10/2025.
//

import LCARSComponents
import SwiftUI

/// Placeholder shown while a personnel file loads
struct ProfileLoadingView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("ACCESSING RECORD")
                .font(.lcars(24))
                .foregroundStyle(Color.lcarTan)

            LCARSDataCascade(seed: "profile-loading", rows: 3)
        }
    }
}
