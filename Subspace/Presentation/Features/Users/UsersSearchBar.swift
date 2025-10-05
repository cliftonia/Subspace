//
//  UsersSearchBar.swift
//  Subspace
//
//  Created by Clifton Baggerman on 06/10/2025.
//

import SwiftUI
import LCARSComponents

/// Search bar for users list
struct UsersSearchBar: View {

    // MARK: - Properties

    @Binding var searchText: String
    let onClear: () -> Void

    // MARK: - Body

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 12))
                .foregroundStyle(Color.lcarViolet)

            Text(searchText.isEmpty ? "SEARCH" : searchText.uppercased())
                .font(.custom("HelveticaNeue-CondensedBold", size: 12))
                .foregroundStyle(searchText.isEmpty ? Color.lcarViolet.opacity(0.5) : Color.lcarWhite)
                .frame(maxWidth: .infinity, alignment: .leading)

            if !searchText.isEmpty {
                Button(action: onClear) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 12))
                        .foregroundStyle(Color.lcarViolet)
                }
            }
        }
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder(Color.lcarViolet, lineWidth: 2)
        )
    }
}
