//
//  Meteorology.swift
//  Gud Tay
//
//  Created by Zev Eisenberg on 8/14/16.
//  Copyright © 2016 Zev Eisenberg. All rights reserved.
//

struct Meteorology {

    enum Wind {

        case none

        /// - `speed`: the wind speed in miles per hour.
        /// - `bearing`: the direction that the wind is coming from in degrees, with
        /// true north at 0° and progressing clockwise.
        case some(speed: Double, bearing: Double)
    }

    /// Between 0 and 1 (inclusive) representing the percentage of sky occluded by clouds.
    let cloudCover: Double

    /// The dew point at the given time in degrees Fahrenheit.
    let dewPoint: Double

    /// Between 0 and 1 (inclusive) representing the relative humidity.
    let humidity: Double

    /// A machine-readable text summary of this data point, suitable for selecting an icon
    /// for display.
    let icon: Icon?

    /// the columnar density of total atmospheric ozone at the given time in Dobson units.
    let ozone: Double

    /// the sea-level air pressure in millibars.
    let pressure: Double

    /// A human-readable text summary of this data point.
    /// - Note: Do not use this value for automated purposes. You should use the `icon` property instead.
    let summary: String

    /// The average visibility in miles, capped at 10 miles.
    let visibility: Double?

    let wind: Wind

}

extension Meteorology: JSONRepresentable {

    init(json: JSONObject) throws {
        visibility = json.optionalValue(key: "visibility")

        do {
            cloudCover = try json.value(key: "cloudCover")
            dewPoint = try json.value(key: "dewPoint")
            humidity = try json.value(key: "humidity")
            icon = try Icon(rawValue: json.value(key: "icon"))
            ozone = try json.value(key: "ozone")
            pressure = try json.value(key: "pressure")
            summary = try json.value(key: "summary")

            let windSpeed: Double = try json.value(key: "windSpeed")
            if windSpeed.isPracticallyZero() {
                wind = .none
            }
            else {
                let windBearing: Double = try json.value(key: "windBearing")
                wind = .some(speed: windSpeed, bearing: windBearing)
            }
        }
        catch let error {
            throw error
        }
    }

}

extension Meteorology: JSONListable { }
