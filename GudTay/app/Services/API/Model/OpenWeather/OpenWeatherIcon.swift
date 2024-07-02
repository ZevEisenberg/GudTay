//
//  OpenWeatherIcon.swift
//  Services
//
//  Created by Zev Eisenberg on 5/29/20.
//

import UIKit.UIImage

public extension OpenWeatherAPI {

    enum Icon: String, Decodable {
        // Day
        case clearSkyDay = "01d"
        case fewCloudsDay = "02d"
        case scatteredCloudsDay = "03d"
        case brokenCloudsDay = "04d"
        case showerRainDay = "09d"
        case rainDay = "10d"
        case thunderstormDay = "11d"
        case snowDay = "13d"
        case mistDay = "50d"

        // Night
        case clearSkyNight = "01n"
        case fewCloudsNight = "02n"
        case scatteredCloudsNight = "03n"
        case brokenCloudsNight = "04n"
        case showerRainNight = "09n"
        case rainNight = "10n"
        case thunderstormNight = "11n"
        case snowNight = "13n"
        case mistNight = "50n"
    }

}

public extension OpenWeatherAPI.Icon {

    var image: UIImage {
        switch self {
        // Clear
        case .clearSkyDay: .clearDay
        case .clearSkyNight: .clearNight

        // Partly Cloudy
        case .fewCloudsDay: .partlyCloudyDay
        case .fewCloudsNight: .partlyCloudyNight
        case .scatteredCloudsDay: .partlyCloudyDay
        case .scatteredCloudsNight: .partlyCloudyNight
        case .brokenCloudsDay: .partlyCloudyDay
        case .brokenCloudsNight: .partlyCloudyNight

        // Rain
        case .showerRainDay, .showerRainNight: .rain
        case .rainDay, .rainNight: .rain
        case .thunderstormDay, .thunderstormNight: .rain

        // Snow
        case .snowDay, .snowNight: .snow

        // Fog
        case .mistDay, .mistNight: .fog
        }
    }

    var smallImage: UIImage {
        switch self {
        // Clear
        case .clearSkyDay: .Small.clearDay
        case .clearSkyNight: .Small.clearNight

        // Other: no small images available
        default: image
        }
    }

}
