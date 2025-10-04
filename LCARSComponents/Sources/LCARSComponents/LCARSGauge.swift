//
//  LCARSGauge.swift
//  ComponentLibrary
//
//  Created by Clifton Baggerman on 04/10/2025.
//

import SwiftUI

/// LCARS gauge - visual indicator for values
public struct LCARSGauge: View {

    // MARK: - Properties

    private let value: Double
    private let range: ClosedRange<Double>
    private let color: Color
    private let backgroundColor: Color
    private let height: CGFloat
    private let cornerRadius: CGFloat
    private let label: String?
    private let showValue: Bool

    // MARK: - Initialization

    public init(
        value: Double,
        in range: ClosedRange<Double> = 0...100,
        color: Color = .lcarOrange,
        backgroundColor: Color = Color.white.opacity(0.2),
        height: CGFloat = 30,
        cornerRadius: CGFloat = 15,
        label: String? = nil,
        showValue: Bool = true
    ) {
        self.value = value
        self.range = range
        self.color = color
        self.backgroundColor = backgroundColor
        self.height = height
        self.cornerRadius = cornerRadius
        self.label = label
        self.showValue = showValue
    }

    // MARK: - Body

    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Label and value
            if label != nil || showValue {
                HStack {
                    if let label = label {
                        Text(label)
                            .font(.custom("HelveticaNeue-CondensedBold", size: 12))
                            .foregroundStyle(color)
                    }

                    Spacer()

                    if showValue {
                        Text(String(format: "%.0f", value))
                            .font(.custom("HelveticaNeue-CondensedBold", size: 12))
                            .foregroundStyle(color)
                    }
                }
            }

            // Gauge bar
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    // Background
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(backgroundColor)
                        .frame(height: height)

                    // Fill
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(color)
                        .frame(
                            width: geo.size.width * percentage,
                            height: height
                        )
                }
            }
            .frame(height: height)
        }
    }

    private var percentage: Double {
        let normalized = (value - range.lowerBound) / (range.upperBound - range.lowerBound)
        return min(max(normalized, 0), 1)
    }
}

// MARK: - Segmented Gauge

/// LCARS segmented gauge - gauge with discrete segments
public struct LCARSSegmentedGauge: View {

    // MARK: - Properties

    private let value: Double
    private let segments: Int
    private let range: ClosedRange<Double>
    private let color: Color
    private let inactiveColor: Color
    private let height: CGFloat
    private let spacing: CGFloat
    private let label: String?

    // MARK: - Initialization

    public init(
        value: Double,
        segments: Int = 10,
        in range: ClosedRange<Double> = 0...100,
        color: Color = .lcarOrange,
        inactiveColor: Color = Color.white.opacity(0.2),
        height: CGFloat = 30,
        spacing: CGFloat = 4,
        label: String? = nil
    ) {
        self.value = value
        self.segments = segments
        self.range = range
        self.color = color
        self.inactiveColor = inactiveColor
        self.height = height
        self.spacing = spacing
        self.label = label
    }

    // MARK: - Body

    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let label = label {
                HStack {
                    Text(label)
                        .font(.custom("HelveticaNeue-CondensedBold", size: 12))
                        .foregroundStyle(color)

                    Spacer()

                    Text(String(format: "%.0f%%", percentage * 100))
                        .font(.custom("HelveticaNeue-CondensedBold", size: 12))
                        .foregroundStyle(color)
                }
            }

            HStack(spacing: spacing) {
                ForEach(0..<segments, id: \.self) { index in
                    RoundedRectangle(cornerRadius: height / 4)
                        .fill(isSegmentActive(index) ? color : inactiveColor)
                        .frame(height: height)
                }
            }
        }
    }

    private var percentage: Double {
        let normalized = (value - range.lowerBound) / (range.upperBound - range.lowerBound)
        return min(max(normalized, 0), 1)
    }

    private func isSegmentActive(_ index: Int) -> Bool {
        let activeSegments = Int(ceil(percentage * Double(segments)))
        return index < activeSegments
    }
}

// MARK: - Preview

#Preview("LCARS Gauges") {
    ZStack {
        Color.lcarBlack
            .ignoresSafeArea()

        ScrollView {
            VStack(spacing: 30) {
                // Standard gauges
                VStack(spacing: 20) {
                    LCARSGauge(
                        value: 75,
                        color: .lcarOrange,
                        label: "POWER SYSTEMS"
                    )

                    LCARSGauge(
                        value: 45,
                        color: .lcarViolet,
                        label: "SHIELD STRENGTH"
                    )

                    LCARSGauge(
                        value: 90,
                        color: .lcarPink,
                        label: "WARP CORE",
                        showValue: true
                    )
                }
                .padding(.horizontal, 20)

                Divider()
                    .background(Color.lcarWhite.opacity(0.3))
                    .padding(.horizontal, 20)

                // Segmented gauges
                VStack(spacing: 20) {
                    LCARSSegmentedGauge(
                        value: 60,
                        segments: 10,
                        color: .lcarTan,
                        label: "SENSOR ARRAY"
                    )

                    LCARSSegmentedGauge(
                        value: 85,
                        segments: 8,
                        color: .lcarLightOrange,
                        label: "IMPULSE ENGINES"
                    )

                    LCARSSegmentedGauge(
                        value: 30,
                        segments: 12,
                        color: .lcarPlum,
                        label: "PHOTON TORPEDOES"
                    )
                }
                .padding(.horizontal, 20)
            }
            .padding(.vertical, 40)
        }
    }
}
