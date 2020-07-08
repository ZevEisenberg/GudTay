//
//  OpenWeatherHourly.swift
//  Services
//
//  Created by Zev Eisenberg on 5/28/20.
//

import Foundation

public extension OpenWeatherAPI {

    struct Daily: Decodable {
        public let date: Date
        public let sunrise: Date
        public let sunset: Date
        public let temp: Temp
        public let feelsLike: FeelsLike
        public let pressure, humidity: Int
        public let dewPoint, windSpeed: Double
        public let windDeg: Int
        public let weather: [Weather]
        public let clouds: Int
        public let uvi: Double?
        public let rain: Double?

        enum CodingKeys: String, CodingKey {
            case date = "dt"
            case sunrise
            case sunset
            case temp
            case feelsLike
            case pressure
            case humidity
            case dewPoint
            case windSpeed
            case windDeg
            case weather
            case clouds
            case uvi
            case rain
        }
    }

}
