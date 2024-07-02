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
        UIImage(resource: resource)
    }

    var smallImage: UIImage {
        UIImage(resource: smallResource)
    }

}

extension OpenWeatherAPI.Icon {

    var resource: ImageResource {
        switch self {
        // Clear
        case .clearSkyDay: return .clearDay
        case .clearSkyNight: return .clearNight

        // Partly Cloudy
        case .fewCloudsDay: return .partlyCloudyDay
        case .fewCloudsNight: return .partlyCloudyNight
        case .scatteredCloudsDay: return .partlyCloudyDay
        case .scatteredCloudsNight: return .partlyCloudyNight
        case .brokenCloudsDay: return .partlyCloudyDay
        case .brokenCloudsNight: return .partlyCloudyNight

        // Rain
        case .showerRainDay, .showerRainNight: return .rain
        case .rainDay, .rainNight: return .rain
        case .thunderstormDay, .thunderstormNight: return .rain

        // Snow
        case .snowDay, .snowNight: return .snow

        // Fog
        case .mistDay, .mistNight: return .fog
        }
    }

    var smallResource: ImageResource {
        switch self {
        // Clear
        case .clearSkyDay: return .Small.clearDay
        case .clearSkyNight: return .Small.clearNight

        // Other: no small images available
        default: return resource
        }
    }

}
