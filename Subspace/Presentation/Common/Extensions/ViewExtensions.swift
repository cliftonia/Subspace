//
//  ViewExtensions.swift
//  Subspace
//
//  Created by Clifton Baggerman on 04/10/2025.
//

import SwiftUI

// MARK: - Corner Radius Extension

extension View {
    /// Applies corner radius to specific corners of a view
    /// - Parameters:
    ///   - radius: The radius of the corner curve
    ///   - corners: The specific corners to round (e.g., .topLeft, .bottomRight)
    /// - Returns: A view with selectively rounded corners
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

// MARK: - Rounded Corner Shape

/// A custom shape that allows rounding specific corners
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    /// Creates a path with rounded corners based on the specified parameters
    /// - Parameter rect: The rectangle in which to create the path
    /// - Returns: A path with selectively rounded corners
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
