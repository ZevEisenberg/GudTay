//
//  WeatherCondition+Icons.swift
//  Services
//
//  Created by Zev Eisenberg on 5/29/20.
//

import UIKit.UIImage
import WeatherKit

public extension WeatherCondition {
    func smallIcon(isDaylight: Bool) -> UIImage {
        switch self {
        case .clear:
            return isDaylight ? .Small.clearDay : .Small.clearNight

            // Other: no small images available
        default:
            return icon(isDaylight: isDaylight)
        }
    }

    func icon(isDaylight: Bool) -> UIImage {
        switch self {
        case .blizzard: .snow
        case .blowingDust: .fog
        case .blowingSnow: .snow
        case .breezy: .wind
        case .clear: isDaylight ? .clearDay : .clearNight
        case .cloudy: isDaylight ? .partlyCloudyDay : .partlyCloudyNight
        case .drizzle: .rain
        case .flurries: .snow
        case .foggy: .fog
        case .freezingDrizzle: .rain
        case .freezingRain: .rain
        case .frigid: .clearDay
        case .hail: .rain
        case .haze: .fog
        case .heavyRain: .rain
        case .heavySnow: .snow
        case .hot: .clearDay
        case .hurricane: .rain
        case .isolatedThunderstorms: .rain
        case .mostlyClear: isDaylight ? .clearDay : .clearNight
        case .mostlyCloudy: isDaylight ? .partlyCloudyDay : .partlyCloudyNight
        case .partlyCloudy: isDaylight ? .partlyCloudyDay : .partlyCloudyNight
        case .rain: .rain
        case .scatteredThunderstorms: .rain
        case .sleet: .rain
        case .smoky: .fog
        case .snow: .snow
        case .strongStorms: .rain
        case .sunFlurries: .snow
        case .sunShowers: .rain
        case .thunderstorms: .rain
        case .tropicalStorm: .rain
        case .windy: .wind
        case .wintryMix: .rain // judgment call
        @unknown default: isDaylight ? .clearDay : .clearNight
        }
    }
}
