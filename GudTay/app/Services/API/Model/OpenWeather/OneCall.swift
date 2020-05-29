//
//  OpenWeatherAPI.swift
//  Services
//
//  Created by Zev Eisenberg on 5/28/20.
//

public extension OpenWeatherAPI {

    struct OneCall: Codable {
        public let lat: Double
        public let lon: Double
        public let timezone: String
        public let timezoneOffset: Int
        public let current: Current
        public let hourly: [Hourly]

        enum CodingKeys: String, CodingKey {
            case lat, lon, timezone
            case timezoneOffset
            case current, hourly
        }
    }

}
