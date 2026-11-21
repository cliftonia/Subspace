//
//  WeatherData.swift
//  Subspace
//
//  Created by Clifton Baggerman on 04/10/2025.
//

import CoreLocation
import Foundation
import os
import WeatherKit

/// Weather data model for LCARS dashboard
@MainActor
@Observable
final class WeatherData {
    // MARK: - Properties

    var dailyForecasts: [DailyForecast] = []
    var isLoading = false
    var error: Error?

    /// Where the current forecast came from
    private(set) var source: WeatherSource?

    private let weatherService = WeatherService()
    private let openMeteo = OpenMeteoService()
    private let logger = Logger.app(category: "WeatherData")

    // MARK: - Methods

    func fetchDailyForecast(for location: CLLocation? = nil) async {
        isLoading = true
        error = nil

        // Default to Brisbane, Australia if no location provided
        let targetLocation = location ?? CLLocation(latitude: -27.4698, longitude: 153.0251)

        do {
            let weather = try await weatherService.weather(for: targetLocation, including: .daily)

            dailyForecasts = weather.forecast.map {
                DailyForecast(
                    date: $0.date,
                    min: $0.lowTemperature.value,
                    max: $0.highTemperature.value
                )
            }
            source = .appleWeather
            logger.debug("Fetched \(self.dailyForecasts.count) daily forecasts")
        } catch {
            logger.error("WeatherKit unavailable: \(error.localizedDescription)")
            await fetchFallbackForecast(for: targetLocation.coordinate)
        }

        isLoading = false
    }

    /// Falls back to Open-Meteo, then to a generated forecast if the network is unavailable too
    private func fetchFallbackForecast(for coordinate: CLLocationCoordinate2D) async {
        do {
            dailyForecasts = try await openMeteo.fetchForecast(for: coordinate)
            source = .openMeteo
        } catch {
            self.error = error
            dailyForecasts = DailyForecast.simulated(from: Date())
            source = .simulated
            logger.error("Failed to fetch weather: \(error.localizedDescription)")
        }
    }
}

// MARK: - Weather Source

/// Where a forecast came from
enum WeatherSource {
    case appleWeather
    case openMeteo
    case simulated

    var title: String {
        switch self {
        case .appleWeather:
            return "Apple Weather"
        case .openMeteo:
            return "Open-Meteo"
        case .simulated:
            return "Simulated sensor data"
        }
    }
}

// MARK: - Daily Forecast Model

nonisolated struct DailyForecast: Identifiable, Sendable {
    let id = UUID()
    let date: Date
    let min: Double
    let max: Double

    /// A plausible ten day forecast for when live weather is unavailable
    /// - Parameter start: The first day of the forecast
    /// - Returns: One forecast per day, with temperatures in degrees Celsius
    static func simulated(from start: Date) -> [DailyForecast] {
        (0..<10).map { day in
            let drift = sin(Double(day) * 0.8) * 4
            return DailyForecast(
                date: start.addingTimeInterval(86400 * Double(day)),
                min: 15 + drift,
                max: 25 + drift + cos(Double(day) * 1.3) * 2
            )
        }
    }
}
