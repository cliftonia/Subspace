//
//  ProfileContentView.swift
//  Subspace
//
//  Created by Clifton Baggerman on 06/10/2025.
//

import LCARSComponents
import SwiftUI

/// Personnel record for a single crew member
struct ProfileContentView: View {
    // MARK: - Properties

    let user: User
    let onOpenComms: () -> Void

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(user.displayName.uppercased())
                .font(.lcars(34, relativeTo: .title))
                .foregroundStyle(Color.lcarOrange)
                .lineLimit(1)
                .minimumScaleFactor(0.6)
                .accessibilityAddTraits(.isHeader)

            LCARSDataCascade(seed: user.id, rows: 3)

            LCARSSectionHeader("Service Record", color: .lcarTan)

            VStack(spacing: 6) {
                LCARSReadoutRow(label: "Service ID", value: serviceNumber, color: .lcarOrange)
                LCARSReadoutRow(label: "Contact", value: user.email, color: .lcarViolet)
                LCARSReadoutRow(label: "Enlisted", value: Stardate.string(for: user.createdAt), color: .lcarTan)
            }

            Button("Open Comms", action: onOpenComms)
                .buttonStyle(.lcars(.lcarOrange))
                .padding(.top, 4)
        }
    }

    // MARK: - Display Values

    private var serviceNumber: String {
        let digits = LCARSUtilities.stableDigits(user.id, count: 7)
        return "SC \(digits.prefix(3))-\(digits.suffix(4))"
    }
}
