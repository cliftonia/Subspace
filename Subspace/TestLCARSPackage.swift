//
//  TestLCARSPackage.swift
//  Subspace
//
//  Created by Clifton Baggerman on 04/10/2025.
//

import LCARSComponents
import SwiftUI

/// Test view to verify LCARSComponents package works
struct TestLCARSPackageView: View {
    var body: some View {
        ZStack {
            Color.lcarBlack
                .ignoresSafeArea()

            VStack(spacing: 20) {
                Text("LCARS PACKAGE TEST")
                    .font(.custom("HelveticaNeue-CondensedBold", size: 24))
                    .foregroundStyle(Color.lcarOrange)

                // Test atomic components from package
                HStack(spacing: 16) {
                    LCARSElbow(
                        position: .topLeading,
                        color: .lcarOrange,
                        size: 60,
                        label: "01"
                    )

                    LCARSElbow(
                        position: .topTrailing,
                        color: .lcarViolet,
                        size: 60,
                        label: "02"
                    )
                }

                // Test gauge
                LCARSGauge(
                    value: 75,
                    color: .lcarPink,
                    label: "PACKAGE STATUS"
                )
                .frame(width: 300)

                // Test bar with end caps
                HStack(spacing: 0) {
                    LCARSEndCap(
                        position: .leading,
                        color: .lcarTan,
                        size: CGSize(width: 40, height: 25)
                    )
                    LCARSBar(
                        orientation: .horizontal,
                        color: .lcarTan,
                        length: 150,
                        thickness: 25,
                        label: "SUCCESS"
                    )
                    LCARSEndCap(
                        position: .trailing,
                        color: .lcarTan,
                        size: CGSize(width: 40, height: 25)
                    )
                }
            }
            .padding(40)
        }
    }
}

#Preview {
    TestLCARSPackageView()
}
