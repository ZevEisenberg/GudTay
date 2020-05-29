//
//  OpenWeatherAPI.swift
//  Services
//
//  Created by Zev Eisenberg on 5/28/20.
//

public extension OpenWeatherAPI {

    enum Main: String, Decodable {
        case ash = "Ash"
        case clear = "Clear"
        case clouds = "Clouds"
        case drizzle = "Drizzle"
        case dust = "Dust"
        case fog = "Fog"
        case haze = "Haze"
        case mist = "Mist"
        case rain = "Rain"
        case sand = "Sand"
        case smoke = "Smoke"
        case snow = "Snow"
        case squall = "Squall"
        case thunderstorm = "Thunderstorm"
        case tornado = "Tornado"
    }

}
