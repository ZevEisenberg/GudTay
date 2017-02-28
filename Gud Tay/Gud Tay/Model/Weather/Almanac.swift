//
//  Almanac.swift
//  Gud Tay
//
//  Created by Zev Eisenberg on 8/14/16.
//  Copyright © 2016 Zev Eisenberg. All rights reserved.
//

import Foundation.NSDate
import JSON

struct Almanac {

    struct TemperatureRange {

        let max: Double
        let min: Double
        let maxTime: Date
        let minTime: Date

    }

    enum PrecipitationType: String {

        case rain = "rain"
        case snow = "snow"
        case sleet = "sleet"

    }

    enum PrecipitationIntensityMax {

        case none

        /// - `value`: the maximumum expected intensity of precipitation on the given day in inches of liquid water per hour.
        /// - `date`: when `precipIntensity` occurs
        case some(value: Double, date: Date)

    }

    let temperatureRange: TemperatureRange
    let apparentTemperatureRange: TemperatureRange

    /// The fractional part of the lunation number of the given day: a value
    /// of 0 corresponds to a new moon, 0.25 to a first quarter moon, 0.5 to
    /// a full moon, and 0.75 to a last quarter moon. (The ranges in between
    /// these represent waxing crescent, waxing gibbous, waning gibbous, and
    /// waning crescent moons, respectively.)
    let moonPhase: Double

    let precipitation: Precipitation

    let precipIntensityMax: PrecipitationIntensityMax

    let precipType: PrecipitationType?

    /// the last sunrise before the solar noon closest to local noon on the given day. (Note: near the poles, this may occur on a different day entirely from `sunsetTime`!)
    let sunriseTime: Date

    /// the first sunset after the solar noon closest to local noon on the given day. (Note: near the poles, this may occur on a different day entirely from `sunriseTime`!)
    let sunsetTime: Date

}

extension Almanac.TemperatureRange {

    init(json: JSON.Object, maxKey: String, minKey: String, maxTimeKey: String, minTimeKey: String) throws {
        max = try json.value(key: maxKey)
        min = try json.value(key: minKey)
        maxTime = try json.date(key: maxTimeKey)
        minTime = try json.date(key: minTimeKey)
    }

}

extension Almanac: JSON.Representable {

    init(json: JSON.Object) throws {
        temperatureRange = try TemperatureRange(
            json: json,
            maxKey: "temperatureMax",
            minKey: "temperatureMin",
            maxTimeKey: "temperatureMaxTime",
            minTimeKey: "temperatureMinTime"
        )

        apparentTemperatureRange = try TemperatureRange(
            json: json,
            maxKey: "apparentTemperatureMax",
            minKey: "apparentTemperatureMin",
            maxTimeKey: "apparentTemperatureMaxTime",
            minTimeKey: "apparentTemperatureMinTime"
        )

        moonPhase = try json.value(key: "moonPhase")

        if let precipIntensityMaxValue: Double = try json.value(key: "precipIntensityMax"), !precipIntensityMaxValue.isPracticallyZero() {
            let precipIntensityMaxTime = try json.date(key: "precipIntensityMaxTime")
            precipIntensityMax = .some(value: precipIntensityMaxValue, date: precipIntensityMaxTime)
        }
        else {
            precipIntensityMax = .none
        }

        precipitation = try Precipitation(json: json)
        if !precipitation.intensity.isPracticallyZero() {
            precipType = try PrecipitationType(rawValue: json.value(key: "precipType"))
        }
        else {
            precipType = nil
        }

        sunriseTime = try json.date(key: "sunriseTime")
        sunsetTime = try json.date(key: "sunsetTime")
    }

}

extension Almanac: JSON.Listable { }
