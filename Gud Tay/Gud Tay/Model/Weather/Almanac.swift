//
//  Almanac.swift
//  Gud Tay
//
//  Created by Zev Eisenberg on 8/14/16.
//  Copyright © 2016 Zev Eisenberg. All rights reserved.
//

import Foundation.NSDate

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

    fileprivate enum CodingKeys: String, CodingKey {
        case temperatureMax = "temperatureMax"
        case temperatureMin = "temperatureMin"
        case temperatureMaxTime = "temperatureMaxTime"
        case temperatureMinTime = "temperatureMinTime"

        case apparentTemperatureMax = "apparentTemperatureMax"
        case apparentTemperatureMin = "apparentTemperatureMin"
        case apparentTemperatureMaxTime = "apparentTemperatureMaxTime"
        case apparentTemperatureMinTime = "apparentTemperatureMinTime"

        case moonPhase = "moonPhase"
        case precipIntensityMax = "precipIntensityMax"
        case precipIntensityMaxTime = "precipIntensityMaxTime"
        case precipType = "precipType"
        case sunriseTime = "sunriseTime"
        case sunsetTime = "sunsetTime"
    }

}

private extension Almanac.TemperatureRange {

    typealias Keys = Almanac.CodingKeys

    init(values: KeyedDecodingContainer<Keys>, maxKey: Keys, minKey: Keys, maxTimeKey: Keys, minTimeKey: Keys) throws {
        max = try values.decode(Double.self, forKey: maxKey)
        min = try values.decode(Double.self, forKey: minKey)
        maxTime = try values.decodeDateCleverly(forKey: maxTimeKey)
        minTime = try values.decodeDateCleverly(forKey: minTimeKey)
    }

}

extension Almanac: Decodable {

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        temperatureRange = try TemperatureRange(
            values: values,
            maxKey: .temperatureMax,
            minKey: .temperatureMin,
            maxTimeKey: .temperatureMaxTime,
            minTimeKey: .temperatureMinTime
        )

        apparentTemperatureRange = try TemperatureRange(
            values: values,
            maxKey: .apparentTemperatureMax,
            minKey: .apparentTemperatureMin,
            maxTimeKey: .apparentTemperatureMaxTime,
            minTimeKey: .apparentTemperatureMinTime
        )

        moonPhase = try values.decode(Double.self, forKey: .moonPhase)

        if let precipIntensityMaxValue = try values.decodeIfPresent(Double.self, forKey: .precipIntensityMax),
            !precipIntensityMaxValue.isPracticallyZero() {
            let precipIntensityMaxTime = try values.decodeDateCleverly(forKey: .precipIntensityMaxTime)
            precipIntensityMax = .some(value: precipIntensityMaxValue, date: precipIntensityMaxTime)
        }
        else {
            precipIntensityMax = .none
        }

        precipitation = try Precipitation(from: decoder)
        if !precipitation.intensity.isPracticallyZero() {
            precipType = try PrecipitationType(rawValue: values.decode(String.self, forKey: .precipType))
        }
        else {
            precipType = nil
        }

        sunriseTime = try values.decodeDateCleverly(forKey: .sunriseTime)
        sunsetTime = try values.decodeDateCleverly(forKey: .sunsetTime)
    }

}
