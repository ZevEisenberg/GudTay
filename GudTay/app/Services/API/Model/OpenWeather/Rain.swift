//
//  OpenWeatherAPI.swift
//  Services
//
//  Created by Zev Eisenberg on 5/28/20.
//

public extension OpenWeatherAPI {

    struct Rain: Codable {
        public let oneHour: Double

        enum CodingKeys: String, CodingKey {
            case oneHour = "1h"
        }
    }

}
