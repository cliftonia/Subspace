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

    @Bindable var weatherData: WeatherData
    @Binding var chartMode: ChartDisplayMode

    // MARK: - Body

    var body: some View {
        VStack(spacing: 12) {
            chart

            LCARSWeightedRow(weights: [1, 1, 1, 1]) {
                ForEach(ChartDisplayMode.allCases) { mode in
                    Button(mode.rawValue) {
                        withAnimation {
                            chartMode = mode
                        }
                    }
                    .buttonStyle(.lcars(.lcarBlue, form: .segment, isSelected: mode == chartMode))
                }
            }
            .frame(height: 48)
        }
    }

    // MARK: - Chart

    private var chart: some View {
        Chart(weatherData.dailyForecasts) { forecast in
            switch chartMode {
            case .lineSymbol:
                seriesLine(forecast, value: forecast.max, name: "High")
                    .foregroundStyle(Color.lcarOrange)
                    .symbol(Circle())
                seriesLine(forecast, value: forecast.min, name: "Low")
                    .foregroundStyle(Color.lcarViolet)
                    .symbol(Circle())

            case .linePlain:
                seriesLine(forecast, value: forecast.max, name: "High")
                    .foregroundStyle(Color.lcarOrange)
                seriesLine(forecast, value: forecast.min, name: "Low")
                    .foregroundStyle(Color.lcarViolet)

            case .bar:
                BarMark(
                    x: .value("Date", forecast.date, unit: .day),
                    yStart: .value("Low", forecast.min),
                    yEnd: .value("High", forecast.max),
                    width: .fixed(12)
                )
                .foregroundStyle(Color.lcarOrange)

            case .area:
                AreaMark(
                    x: .value("Date", forecast.date),
                    yStart: .value("Low", forecast.min),
                    yEnd: .value("High", forecast.max)
                )
                .foregroundStyle(Color.lcarTan)
            }
        }
        .chartLegend(.hidden)
        .chartXAxis {
            AxisMarks(values: .stride(by: .day, count: 2)) { _ in
                AxisGridLine().foregroundStyle(Color.lcarBlue.opacity(0.3))
                AxisValueLabel(format: .dateTime.weekday(.abbreviated))
                    .font(.lcars(15))
                    .foregroundStyle(Color.lcarBlue)
            }
        }
        .chartYAxis {
            AxisMarks { _ in
                AxisGridLine().foregroundStyle(Color.lcarBlue.opacity(0.3))
                AxisValueLabel()
                    .font(.lcars(15))
                    .foregroundStyle(Color.lcarBlue)
            }
        }
        .frame(height: 240)
        .accessibilityLabel("Forecast of daily high and low temperatures")
    }

    private func seriesLine(_ forecast: DailyForecast, value: Double, name: String) -> LineMark {
        LineMark(
            x: .value("Date", forecast.date),
            y: .value("Temperature", value),
            series: .value("Series", name)
        )
    }
}
