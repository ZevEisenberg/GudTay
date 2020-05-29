//
//  OpenWeatherAPI.swift
//  Services
//
//  Created by Zev Eisenberg on 5/28/20.
//

public extension OpenWeatherAPI {

    enum Description: String, Decodable {
        case brokenClouds = "broken clouds"
        case lightRain = "light rain"
        case moderateRain = "moderate rain"
        case overcastClouds = "overcast clouds"
    }

}
