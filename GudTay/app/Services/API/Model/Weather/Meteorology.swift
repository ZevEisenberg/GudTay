//
//  Meteorology.swift
//  Services
//
//  Created by Zev Eisenberg on 8/14/16.
//  Copyright © 2016 Zev Eisenberg. All rights reserved.
//

import Utilities

public struct Meteorology {

    public enum Wind {

        case none

        /// - `speed`: the wind speed in miles per hour.
        /// - `bearing`: the direction that the wind is coming from in degrees, with
        /// true north at 0° and progressing clockwise.
        case some(speed: Double, bearing: Double)
    }

    /// Between 0 and 1 (inclusive) representing the percentage of sky occluded by clouds.
    public let cloudCover: Double?

    /// The dew point at the given time in degrees Fahrenheit.
    public let dewPoint: Double

    /// Between 0 and 1 (inclusive) representing the relative humidity.
    public let humidity: Double

    /// A machine-readable text summary of this data point, suitable for selecting an icon
    /// for display.
    public let icon: Icon?

    /// the columnar density of total atmospheric ozone at the given time in Dobson units.
    public let ozone: Double

    /// the sea-level air pressure in millibars.
    public let pressure: Double

    /// A human-readable text summary of this data point.
    /// - Note: Do not use this value for automated purposes. You should use the `icon` property instead.
    public let summary: String

    /// The average visibility in miles, capped at 10 miles.
    public let visibility: Double?

    public let wind: Wind

}

extension Meteorology: Decodable {

    private enum CodingKeys: String, CodingKey {
        case visibility
        case cloudCover
        case dewPoint
        case humidity
        case icon
        case ozone
        case pressure
        case summary
        case windSpeed
        case windBearing
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        visibility = try values.decodeIfPresent(Double.self, forKey: .visibility)
        cloudCover = try values.decodeIfPresent(Double.self, forKey: .cloudCover)

        dewPoint = try values.decode(Double.self, forKey: .dewPoint)
        humidity = try values.decode(Double.self, forKey: .humidity)
        icon = try values.decodeIfPresent(String.self, forKey: .icon).flatMap(Icon.init(rawValue:))
        ozone = try values.decode(Double.self, forKey: .ozone)
        pressure = try values.decode(Double.self, forKey: .pressure)
        summary = try values.decode(String.self, forKey: .summary)

        let windSpeed = try values.decode(Double.self, forKey: .windSpeed)
        if windSpeed.isPracticallyZero() {
            wind = .none
        }
        else {
            let windBearing = try values.decode(Double.self, forKey: .windBearing)
            wind = .some(speed: windSpeed, bearing: windBearing)
        }
    }

}
