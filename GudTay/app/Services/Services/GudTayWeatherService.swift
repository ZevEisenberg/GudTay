//
//  GudTayWeatherService.swift
//  Services
//
//  Created by Zev Eisenberg on 5/28/20.
//

import CoreLocation
import Foundation
import Utilities
import WeatherKit

public enum GudTayWeatherService {

    public static func forecast() async throws -> (current: CurrentWeather, hourly: Forecast<HourWeather>, daily: Forecast<DayWeather>) {
        let boston = CLLocation(latitude: 42.3601, longitude: -71.0589)
        return try await WeatherService.shared.weather(for: boston, including: .current, .hourly, .daily)
    }

}
