//
//  DashboardChartView.swift
//  Subspace
//
//  Created by Clifton Baggerman on 06/10/2025.
//

import Charts
import LCARSComponents
import SwiftUI

/// Dashboard chart with mode selector
struct DashboardChartView: View {
    // MARK: - Properties

    @ObservedObject var weatherData: WeatherData
    @Binding var chartMode: ChartDisplayMode
    let attributionLink: URL
    let attributionLogo: URL?

    // MARK: - Body

    var body: some View {
        VStack(spacing: 16) {
            chart

            chartButtons

            if let logoURL = attributionLogo {
                Link(destination: attributionLink) {
                    AsyncImage(url: logoURL)
                        .colorInvert()
                        .scaleEffect(0.65)
                        .opacity(0.25)
                }
            }
        }
        .frame(width: 300)
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
