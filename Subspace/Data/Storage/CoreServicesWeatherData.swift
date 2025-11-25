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

    private let weatherService = WeatherService()
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
            logger.debug("Fetched \(self.dailyForecasts.count) daily forecasts")
        } catch {
            self.error = error
            logger.error("Failed to fetch weather: \(error.localizedDescription)")
        }

        isLoading = false
    }
}

// MARK: - Daily Forecast Model

struct DailyForecast: Identifiable {
    let id = UUID()
    let date: Date
    let min: Double
    let max: Double
}
