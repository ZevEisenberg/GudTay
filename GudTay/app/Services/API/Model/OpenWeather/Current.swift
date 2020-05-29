//
//  OpenWeatherAPI.swift
//  Services
//
//  Created by Zev Eisenberg on 5/28/20.
//

public extension OpenWeatherAPI {

    struct Current: Codable {
        public let dt: Int
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
            case dt, sunrise, sunset, temp
            case feelsLike
            case pressure, humidity
            case dewPoint
            case uvi, clouds, visibility
            case windSpeed
            case windDeg
            case windGust
            case weather
        }
    }

}
