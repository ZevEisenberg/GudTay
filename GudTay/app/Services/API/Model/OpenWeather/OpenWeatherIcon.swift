//
//  OpenWeatherIcon.swift
//  Services
//
//  Created by Zev Eisenberg on 5/29/20.
//

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

extension OpenWeatherAPI.Icon {

    var asset: ImageAsset {
        switch self {
        // Clear
        case .clearSkyDay: return Asset.clearDay
        case .clearSkyNight: return Asset.clearNight

        // Partly Cloudy
        case .fewCloudsDay: return Asset.partlyCloudyDay
        case .fewCloudsNight: return Asset.partlyCloudyNight
        case .scatteredCloudsDay: return Asset.partlyCloudyDay
        case .scatteredCloudsNight: return Asset.partlyCloudyNight
        case .brokenCloudsDay: return Asset.partlyCloudyDay
        case .brokenCloudsNight: return Asset.partlyCloudyNight

        // Rain
        case .showerRainDay, .showerRainNight: return Asset.rain
        case .rainDay, .rainNight: return Asset.rain
        case .thunderstormDay, .thunderstormNight: return Asset.rain

        // Snow
        case .snowDay, .snowNight: return Asset.snow

        // Fog
        case .mistDay, .mistNight: return Asset.fog
        }
    }

    var smallAsset: ImageAsset {
        switch self {
        // Clear
        case .clearSkyDay: return Asset.Small.clearDay
        case .clearSkyNight: return Asset.Small.clearNight

        // Other: no small images available
        default: return asset
        }
    }

}
