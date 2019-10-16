//
//  Almanac.swift
//  Services
//
//  Created by Zev Eisenberg on 8/14/16.
//  Copyright © 2016 Zev Eisenberg. All rights reserved.
//

import Foundation.NSDate

public struct Almanac {

    public struct TemperatureRange {

        public let max: Double
        public let min: Double
        public let maxTime: Date
        public let minTime: Date

    }

    public enum PrecipitationType: String {

        case rain
        case snow
        case sleet

    }

    public enum PrecipitationIntensityMax {

        case none

        /// - `value`: the maximumum expected intensity of precipitation on the given day in inches of liquid water per hour.
        /// - `date`: when `precipIntensity` occurs
        case some(value: Double, date: Date)

    }

    public let temperatureRange: TemperatureRange
    public let apparentTemperatureRange: TemperatureRange

    /// The fractional part of the lunation number of the given day: a value
    /// of 0 corresponds to a new moon, 0.25 to a first quarter moon, 0.5 to
    /// a full moon, and 0.75 to a last quarter moon. (The ranges in between
    /// these represent waxing crescent, waxing gibbous, waning gibbous, and
    /// waning crescent moons, respectively.)
    public let moonPhase: Double

    public let precipitation: Precipitation

    public let precipIntensityMax: PrecipitationIntensityMax

    public let precipType: PrecipitationType?

    /// the last sunrise before the solar noon closest to local noon on the given day. (Note: near the poles, this may occur on a different day entirely from `sunsetTime`!)
    public let sunriseTime: Date

    /// the first sunset after the solar noon closest to local noon on the given day. (Note: near the poles, this may occur on a different day entirely from `sunriseTime`!)
    public let sunsetTime: Date

    fileprivate enum CodingKeys: String, CodingKey {
        case temperatureMax
        case temperatureMin
        case temperatureMaxTime
        case temperatureMinTime

        case apparentTemperatureMax
        case apparentTemperatureMin
        case apparentTemperatureMaxTime
        case apparentTemperatureMinTime

        case moonPhase
        case precipIntensityMax
        case precipIntensityMaxTime
        case precipType
        case sunriseTime
        case sunsetTime
    }

}

private extension Almanac.TemperatureRange {

    typealias Keys = Almanac.CodingKeys

    init(values: KeyedDecodingContainer<Keys>, maxKey: Keys, minKey: Keys, maxTimeKey: Keys, minTimeKey: Keys) throws {
        max = try values.decode(Double.self, forKey: maxKey)
        min = try values.decode(Double.self, forKey: minKey)
        maxTime = try values.decode(Date.self, forKey: maxTimeKey)
        minTime = try values.decode(Date.self, forKey: minTimeKey)
    }

}

extension Almanac: Decodable {

    public init(from decoder: Decoder) throws {
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
            let precipIntensityMaxTime = try values.decode(Date.self, forKey: .precipIntensityMaxTime)
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

        sunriseTime = try values.decode(Date.self, forKey: .sunriseTime)
        sunsetTime = try values.decode(Date.self, forKey: .sunsetTime)
    }

}
