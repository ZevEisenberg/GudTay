//
//  OpenWeatherAPI.swift
//  Services
//
//  Created by Zev Eisenberg on 5/28/20.
//

public extension OpenWeatherAPI {

    struct OneCall: Decodable {
        public let lat: Double
        public let lon: Double
        public let timezone: String
        public let timezoneOffset: Int
        public let current: Current
        public let hourly: [Hourly]
        public let daily: [Daily]

        enum CodingKeys: String, CodingKey {
            case lat
            case lon
            case timezone
            case timezoneOffset
            case current
            case hourly
            case daily
        }
    }

}
