//
//  ColorsShowcaseView.swift
//  ComponentLibrary
//
//  Created by Clifton Baggerman on 04/10/2025.
//

import SwiftUI
import LCARSComponents

/// Showcase view for LCARS color palette
struct ColorsShowcaseView: View {
    var body: some View {
        VStack(spacing: 12) {
            ForEach(LCARSColorPalette.all) { palette in
                HStack(spacing: 12) {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(palette.color)
                        .frame(width: 80, height: 60)
                        .overlay {
                            RoundedRectangle(cornerRadius: 15)
                                .strokeBorder(Color.white.opacity(0.1), lineWidth: 1)
                        }

                    VStack(alignment: .leading, spacing: 4) {
                        Text(palette.name)
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(Color.lcarWhite)

                        Text(palette.hex)
                            .font(.system(size: 12, design: .monospaced))
                            .foregroundStyle(Color.lcarWhite.opacity(0.6))
                    }

                    Spacer()
                }
                .padding(8)
                .background(Color.white.opacity(0.05))
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
        }
    }
}
