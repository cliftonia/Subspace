//
//  WeatherData.swift
//  Subspace
//
//  Created by Clifton Baggerman on 04/10/2025.
//

import Combine
import CoreLocation
import Foundation
import WeatherKit

/// Weather data model for LCARS dashboard
@MainActor
final class WeatherData: ObservableObject {
    // MARK: - Properties

    @Published var dailyForecasts: [DailyForecast] = []
    @Published var isLoading = false
    @Published var error: Error?

    private let weatherService = WeatherService()

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
        } catch {
            self.error = error
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
