//
//  OpenWeatherDailiy.swift
//  Services
//
//  Created by Zev Eisenberg on 5/28/20.
//

import Foundation

public extension OpenWeatherAPI {

    struct Hourly: Decodable {
        public let date: Date
        public let temp: Double
        public let feelsLike: Double
        public let pressure: Int
        public let humidity: Int
        public let dewPoint: Double
        public let clouds: Int
        public let windSpeed: Double
        public let windDeg: Int
        public let weather: [Weather]
        private let pop: Double // Probability of Precipitation

        enum CodingKeys: String, CodingKey {
            case date = "dt"
            case temp
            case feelsLike
            case pressure
            case humidity
            case dewPoint
            case clouds
            case windSpeed
            case windDeg
            case weather
            case pop
        }

        public var probabilityOfPrecipitation: Double {
            pop
        }
    }

}
