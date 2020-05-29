//
//  OpenWeatherAPI.swift
//  Services
//
//  Created by Zev Eisenberg on 5/28/20.
//

public extension OpenWeatherAPI {

    struct Hourly: Codable {
        public let dt: Int
        public let temp: Double
        public let feelsLike: Double
        public let pressure: Int
        public let humidity: Int
        public let dewPoint: Double
        public let clouds: Int
        public let windSpeed: Double
        public let windDeg: Int
        public let weather: [Weather]
        public let rain: Rain?

        enum CodingKeys: String, CodingKey {
            case dt
            case temp
            case feelsLike
            case pressure
            case humidity
            case dewPoint
            case clouds
            case windSpeed
            case windDeg
            case weather
            case rain
        }
    }

}
