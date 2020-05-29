//
//  OpenWeatherAPI.swift
//  Services
//
//  Created by Zev Eisenberg on 5/28/20.
//

public extension OpenWeatherAPI {

    enum Main: String, Decodable {
        case clouds = "Clouds"
        case rain = "Rain"
    }

}
