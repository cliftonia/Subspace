//
//  LCARSDashboardView.swift
//  Subspace
//
//  Created by Clifton Baggerman on 04/10/2025.
//

import Charts
import LCARSComponents
import SwiftUI
import WeatherKit

/// Chart display options
enum ChartDisplayMode {
    case lineSymbol
    case linePlain
    case bar
    case area
}

/// LCARS-themed dashboard with weather charts
struct LCARSDashboardView: View {
    // MARK: - Properties

    @StateObject private var weatherData = WeatherData()
    @State private var chartMode: ChartDisplayMode = .lineSymbol
    @State private var attributionLink = URL(string: "https://www.apple.com")!
    @State private var attributionLogo: URL?

    // MARK: - Body

    var body: some View {
        LCARSContentInFrame(
            topColors: [.lcarPink, .lcarViolet],
            bottomColors: [.lcarPlum, .lcarPlum, .lcarOrange, .lcarTan],
            topTitle: "WEATHER DATA \(LCARSUtilities.randomDigits(3))",
            bottomTitle: "ANALYTICS \(LCARSUtilities.randomDigits(3))",
            topCode: "WX",
            bottomCode: "",
            bottomLabels: [("TMP", ""), ("CHT", ""), ("FCS", ""), ("SYS", "")],
            contentWidth: 300,
            contentHeight: 400
        ) {
            DashboardChartView(
                weatherData: weatherData,
                chartMode: $chartMode,
                attributionLink: attributionLink,
                attributionLogo: attributionLogo
            )
        }
        .task {
            await weatherData.fetchDailyForecast()
            if let attribution = try? await WeatherService.shared.attribution {
                attributionLink = attribution.legalPageURL
                attributionLogo = attribution.combinedMarkDarkURL
            }
        }
    }
}

// MARK: - Preview

#Preview {
    LCARSDashboardView()
}
