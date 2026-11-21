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
enum ChartDisplayMode: String, CaseIterable, Identifiable {
    case lineSymbol = "Points"
    case linePlain = "Lines"
    case bar = "Bars"
    case area = "Range"

    var id: String { rawValue }
}

/// Long range sensors: a temperature forecast plotted on the console
struct LCARSDashboardView: View {
    // MARK: - Properties

    @State private var weatherData = WeatherData()
    @State private var chartMode: ChartDisplayMode = .lineSymbol
    @State private var attributionLink: URL?

    // MARK: - Body

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                LCARSSectionHeader("Thermal Forecast", color: .lcarBlue)

                if weatherData.dailyForecasts.isEmpty {
                    Text("SCANNING")
                        .font(.lcars(24))
                        .foregroundStyle(Color.lcarBlue)
                } else {
                    DashboardChartView(weatherData: weatherData, chartMode: $chartMode)
                }

                if let source = weatherData.source {
                    LCARSReadoutRow(label: "Source", value: source.title, color: .lcarBlue)
                }

                if let attributionLink {
                    Link("Weather data attribution", destination: attributionLink)
                        .font(.lcarsBody(14))
                        .foregroundStyle(Color.lcarViolet)
                }
            }
            .padding(.bottom, 16)
        }
        .scrollIndicators(.hidden)
        .task {
            await weatherData.fetchDailyForecast()
            if let source = weatherData.source {
                attributionLink = await attributionURL(for: source)
            }
        }
    }

    // MARK: - Attribution

    private func attributionURL(for source: WeatherSource) async -> URL? {
        switch source {
        case .appleWeather:
            return try? await WeatherService.shared.attribution.legalPageURL
        case .openMeteo:
            return OpenMeteoService.attributionURL
        case .simulated:
            return nil
        }
    }
}

// MARK: - Preview

#Preview {
    LCARSDashboardView()
}
