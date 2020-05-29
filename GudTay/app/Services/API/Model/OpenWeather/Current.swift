//
//  OpenWeatherAPI.swift
//  Services
//
//  Created by Zev Eisenberg on 5/28/20.
//

import Foundation

public extension OpenWeatherAPI {

    struct Current: Decodable {
        public let date: Date
        public let sunrise: Date
        public let sunset: Date
        public let temp: Double
        public let feelsLike: Double
        public let pressure: Int
        public let humidity: Int
        public let dewPoint: Double
        public let uvi: Double
        public let clouds: Int
        public let visibility: Int?
        public let windSpeed: Double
        public let windDeg: Int
        public let windGust: Double

        /// It's possible to get more than one Weather, such as mist + light intensity drizzle.
        /// The first one is considered "primary". See also: [Documentation](https://openweathermap.org/weather-conditions)
        public let weather: [Weather]

        enum CodingKeys: String, CodingKey {
            case date = "dt"
            case sunrise
            case sunset
            case temp
            case feelsLike
            case pressure
            case humidity
            case dewPoint
            case uvi
            case clouds
            case visibility
            case windSpeed
            case windDeg
            case windGust
            case weather
        }
    }

}
