//
//  FeelsLike.swift
//  Services
//
//  Created by Zev Eisenberg on 5/29/20.
//

public extension OpenWeatherAPI {

    struct FeelsLike: Decodable {
        let day: Double
        let night: Double
        let eve: Double
        let morn: Double
    }

}
