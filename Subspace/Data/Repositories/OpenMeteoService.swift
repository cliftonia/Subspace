//
//  OpenMeteoService.swift
//  Subspace
//
//  Created by Clifton Baggerman on 30/10/2026.
//

import CoreLocation
import Foundation

/// The column-oriented daily forecast returned by Open-Meteo
private nonisolated struct OpenMeteoDailyColumns: Decodable {
    let time: [String]
    let temperatureMax: [Double]
    let temperatureMin: [Double]

    enum CodingKeys: String, CodingKey {
        case time
        case temperatureMax = "temperature_2m_max"
        case temperatureMin = "temperature_2m_min"
    }
}

/// Fetches daily forecasts from Open-Meteo, a free service that needs no key or Apple account
nonisolated struct OpenMeteoService: Sendable {
    // MARK: - Types

    private struct ForecastResponse: Decodable {
        let daily: OpenMeteoDailyColumns
    }

    // MARK: - Properties

    /// Open-Meteo asks for attribution wherever its data appears
    static let attributionURL = URL(string: "https://open-meteo.com/")

    private let urlSession: URLSession

    // MARK: - Initialization

    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }

    // MARK: - Public Methods

    /// Fetches the daily forecast for a location
    /// - Parameter coordinate: The location to forecast
    /// - Returns: One forecast per day, with temperatures in degrees Celsius
    func fetchForecast(for coordinate: CLLocationCoordinate2D) async throws -> [DailyForecast] {
        var components = URLComponents(string: "https://api.open-meteo.com/v1/forecast")
        components?.queryItems = [
            URLQueryItem(name: "latitude", value: String(coordinate.latitude)),
            URLQueryItem(name: "longitude", value: String(coordinate.longitude)),
            URLQueryItem(name: "daily", value: "temperature_2m_max,temperature_2m_min"),
            URLQueryItem(name: "timezone", value: "auto"),
            URLQueryItem(name: "forecast_days", value: "10")
        ]

        guard let url = components?.url else {
            throw NetworkError.invalidResponse
        }

        let (data, response) = try await urlSession.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidResponse
        }

        return try Self.forecasts(from: data)
    }

    /// Decodes a forecast response into daily forecasts
    /// - Parameter data: The JSON body returned by Open-Meteo
    /// - Returns: One forecast for each day present in every column
    static func forecasts(from data: Data) throws -> [DailyForecast] {
        let daily = try JSONDecoder().decode(ForecastResponse.self, from: data).daily

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd"

        return zip(daily.time, zip(daily.temperatureMax, daily.temperatureMin)).compactMap { day, temperatures in
            formatter.date(from: day).map { date in
                DailyForecast(date: date, min: temperatures.1, max: temperatures.0)
            }
        }
    }
}
