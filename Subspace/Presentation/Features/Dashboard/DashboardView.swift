//
//  LCARSDashboardView.swift
//  Subspace
//
//  Created by Clifton Baggerman on 04/10/2025.
//

import SwiftUI
import Charts
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
    @State private var attributionLink: URL = URL(string: "https://www.apple.com")!
    @State private var attributionLogo: URL?

    // MARK: - Body

    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color.lcarBlack.ignoresSafeArea()

                VStack(spacing: 10) {
                    topFrame.frame(height: max(geo.size.height / 3, 100))
                    bottomFrame.frame(height: max(geo.size.height * 0.67 - 10, 100))
                }

                // Chart
                chart
                    .offset(x: 60, y: 70)

                // Chart type buttons
                chartButtons
                    .offset(x: 85, y: 300)

                // Weather attribution
                if let logoURL = attributionLogo {
                    Link(destination: attributionLink) {
                        AsyncImage(url: logoURL)
                            .colorInvert()
                            .scaleEffect(0.65)
                            .opacity(0.25)
                    }
                    .offset(x: 50, y: 220)
                }
            }
        }
        .ignoresSafeArea()
        .task {
            await weatherData.fetchDailyForecast()
            if let attribution = try? await WeatherService.shared.attribution {
                attributionLink = attribution.legalPageURL
                attributionLogo = attribution.combinedMarkDarkURL
            }
        }
    }

    // MARK: - LCARS Frame Components

    private var topFrame: some View {
        GeometryReader { geo in
            ZStack {
                VStack(spacing: 5) {
                    Color.lcarPink
                    Color.lcarViolet
                }
                .cornerRadius(70, corners: .bottomLeft)
                .overlay(alignment: .topTrailing) {
                    if geo.size.width > 100 && geo.size.height > 20 {
                    Color.lcarBlack
                        .cornerRadius(35, corners: .bottomLeft)
                        .frame(width: geo.size.width - 100, height: geo.size.height - 20)
                    }
                }
                .overlay(alignment: .topLeading) {
                    Color.lcarBlack
                        .frame(width: 100, height: 50)
                }
                .overlay(alignment: .bottomTrailing) {
                    ZStack {
                        Color.lcarBlack
                        HStack(spacing: 5) {
                            Color.lcarViolet
                                .frame(width: 20)
                                .padding(.leading, 5)
                            Color.lcarPlum
                                .frame(width: 50)
                            Color.lcarOrange
                            Color.lcarTan
                                .frame(width: 20)
                        }
                    }
                    .frame(width: 200, height: 20)
                }
                .overlay(alignment: .leading) {
                    VStack(alignment: .trailing, spacing: 15) {
                        Text("LCARS \(LCARSUtilities.randomDigits(5))")
                        Text("WX-\(LCARSUtilities.randomDigits(6))")
                    }
                    .font(.custom("HelveticaNeue-CondensedBold", size: 17))
                    .foregroundStyle(Color.lcarBlack)
                    .scaleEffect(x: 0.7, anchor: .trailing)
                    .frame(width: 90)
                }
                .overlay(alignment: .topTrailing) {
                    Text("WEATHER DATA \(LCARSUtilities.randomDigits(3))")
                        .font(.custom("HelveticaNeue-CondensedBold", size: 35))
                        .padding(.top, 45)
                        .foregroundStyle(Color.lcarOrange)
                        .scaleEffect(x: 0.7, anchor: .trailing)
                }
                .overlay(alignment: .trailing) {
                    weatherStatsGrid
                        .padding(.top, 40)
                }
            }
        }
    }

    private var weatherStatsGrid: some View {
        Grid(alignment: .trailing) {
            ForEach(0..<7) { row in
                GridRow {
                    ForEach(0..<5) { _ in
                        Text(LCARSUtilities.randomDigits(Int.random(in: 1...6)))
                            .foregroundStyle((row == 1 || row == 5) ? Color.lcarWhite : Color.lcarPink)
                    }
                }
            }
        }
        .font(.custom("HelveticaNeue-CondensedBold", size: 17))
    }

    private var bottomFrame: some View {
        GeometryReader { geo in
            ZStack {
                VStack(alignment: .leading, spacing: 5) {
                    Color.lcarPlum
                        .frame(height: 100)
                        .overlay(alignment: .bottomLeading) {
                            LCARSUtilities.commonLabel(prefix: "TMP")
                                .padding(.bottom, 5)
                        }
                    Color.lcarPlum
                        .frame(height: 200)
                        .overlay(alignment: .bottomLeading) {
                            LCARSUtilities.commonLabel(prefix: "CHT")
                                .padding(.bottom, 5)
                        }
                    Color.lcarOrange
                        .frame(height: 50)
                        .overlay(alignment: .leading) {
                            LCARSUtilities.commonLabel(prefix: "FCS")
                        }
                    Color.lcarTan
                        .overlay(alignment: .topLeading) {
                            LCARSUtilities.commonLabel(prefix: "SYS")
                                .padding(.top, 5)
                        }
                }
                .cornerRadius(70, corners: .topLeft)
                .overlay(alignment: .bottomTrailing) {
                    if geo.size.width > 100 && geo.size.height > 20 {
                    Color.lcarBlack
                        .cornerRadius(35, corners: .topLeft)
                        .frame(width: geo.size.width - 100, height: geo.size.height - 20)
                    }
                }
                .overlay(alignment: .bottomLeading) {
                    Color.lcarBlack
                        .frame(width: 100, height: 50)
                }
                .overlay(alignment: .topTrailing) {
                    ZStack {
                        Color.lcarBlack
                        HStack(alignment: .top, spacing: 5) {
                            Color.lcarOrange
                                .frame(width: 20)
                                .padding(.leading, 5)
                            Color.lcarPink
                                .frame(width: 50, height: 10)
                            Color.lcarViolet
                            Color.lcarPlum
                                .frame(width: 20)
                        }
                    }
                    .frame(width: 200, height: 20)
                }
                .overlay(alignment: .bottomTrailing) {
                    Text("ANALYTICS \(LCARSUtilities.randomDigits(3))")
                        .font(.custom("HelveticaNeue-CondensedBold", size: 35))
                        .padding(.bottom, 45)
                        .foregroundStyle(Color.lcarOrange)
                        .scaleEffect(x: 0.7, anchor: .trailing)
                }
            }
        }
    }

    // MARK: - Chart View

    @ViewBuilder
    private var chart: some View {
        Chart {
            switch chartMode {
            case .lineSymbol:
                ForEach(weatherData.dailyForecasts) { forecast in
                    LineMark(
                        x: .value("Date", forecast.date),
                        y: .value("Temperature", forecast.max),
                        series: .value("High", "High")
                    )
                    .foregroundStyle(Color.lcarPlum)
                    .symbol(Circle())
                }
                ForEach(weatherData.dailyForecasts) { forecast in
                    LineMark(
                        x: .value("Date", forecast.date),
                        y: .value("Temperature", forecast.min),
                        series: .value("Low", "Low")
                    )
                    .foregroundStyle(Color.lcarViolet)
                    .symbol(Circle())
                }

            case .linePlain:
                ForEach(weatherData.dailyForecasts) { forecast in
                    LineMark(
                        x: .value("Date", forecast.date),
                        y: .value("Temperature", forecast.max),
                        series: .value("High", "High")
                    )
                    .foregroundStyle(Color.lcarPlum)
                }
                ForEach(weatherData.dailyForecasts) { forecast in
                    LineMark(
                        x: .value("Date", forecast.date),
                        y: .value("Temperature", forecast.min),
                        series: .value("Low", "Low")
                    )
                    .foregroundStyle(Color.lcarViolet)
                }

            case .bar:
                ForEach(weatherData.dailyForecasts) { forecast in
                    BarMark(
                        x: .value("Date", forecast.date, unit: .day),
                        y: .value("Temperature", forecast.max)
                    )
                    .foregroundStyle(Color.lcarPlum)
                }
                .foregroundStyle(by: .value("Type", "High"))
                .position(by: .value("Type", "High"))

                ForEach(weatherData.dailyForecasts) { forecast in
                    BarMark(
                        x: .value("Date", forecast.date, unit: .day),
                        y: .value("Temperature", forecast.min),
                        stacking: .unstacked
                    )
                    .foregroundStyle(Color.lcarViolet)
                }
                .foregroundStyle(by: .value("Type", "Low"))
                .position(by: .value("Type", "Low"))

            case .area:
                ForEach(weatherData.dailyForecasts) { forecast in
                    AreaMark(
                        x: .value("Date", forecast.date),
                        yStart: .value("High", forecast.max),
                        yEnd: .value("Low", forecast.min)
                    )
                    .foregroundStyle(Color.lcarLightOrange)
                    .opacity(0.9)
                }
            }
        }
        .chartLegend(.hidden)
        .frame(width: 300, height: 250)
        .preferredColorScheme(.dark)
    }

    // MARK: - Chart Buttons

    private var chartButtons: some View {
        Grid {
            GridRow {
                chartButton(mode: .lineSymbol, color: Color.lcarViolet)
                chartButton(mode: .linePlain, color: Color.lcarTan)
            }
            GridRow {
                chartButton(mode: .bar, color: Color.lcarOrange)
                chartButton(mode: .area, color: Color.lcarViolet)
            }
        }
        .frame(width: 300, height: 150)
    }

    @ViewBuilder
    private func chartButton(mode: ChartDisplayMode, color: Color) -> some View {
        Button {
            withAnimation {
                chartMode = mode
            }
        } label: {
            RoundedRectangle(cornerRadius: 20)
                .fill(color)
                .frame(width: 125, height: 50)
                .overlay(alignment: .bottomTrailing) {
                    HStack {
                        Spacer()
                        Text("\(LCARSUtilities.randomDigits(4))-\(LCARSUtilities.randomDigits(3))")
                            .font(.custom("HelveticaNeue-CondensedBold", size: 17))
                            .foregroundStyle(Color.lcarBlack)
                    }
                    .scaleEffect(x: 0.7, anchor: .trailing)
                    .padding(.bottom, 5)
                    .padding(.trailing, 20)
                }
        }
    }
}

// MARK: - Preview

#Preview {
    LCARSDashboardView()
}
