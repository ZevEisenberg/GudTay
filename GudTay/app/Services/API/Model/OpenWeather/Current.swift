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
        public let sunrise: Int
        public let sunset: Int
        public let temp: Double
        public let feelsLike: Double
        public let pressure, humidity: Int
        public let dewPoint: Double
        public let uvi: Double
        public let clouds: Int
        public let visibility: Int
        public let windSpeed: Double
        public let windDeg: Int
        public let windGust: Double
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
