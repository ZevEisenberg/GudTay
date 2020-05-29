//
//  Temp.swift
//  Services
//
//  Created by Zev Eisenberg on 5/29/20.
//

public extension OpenWeatherAPI {

    struct Temp: Decodable {
        public let day: Double
        public let min: Double
        public let max: Double
        public let night: Double
        public let eve: Double
        public let morn: Double
    }

}
