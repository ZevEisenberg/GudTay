//
//  Precipitation.swift
//  Gud Tay
//
//  Created by Zev Eisenberg on 8/14/16.
//  Copyright © 2016 Zev Eisenberg. All rights reserved.
//

import Foundation.NSDate

struct Precipitation {

    /// A numerical value representing the average expected intensity (in inches of liquid water per hour)
    /// of precipitation occurring at the given time conditional on probability (that is, assuming any
    /// precipitation occurs at all). A _very_ rough guide:
    ///
    /// - 0 in./hr. corresponds to no precipitation
    /// - 0.002 in./hr. corresponds to very light precipitation
    /// - 0.017 in./hr. corresponds to light precipitation
    /// - 0.1 in./hr. corresponds to moderate precipitation
    /// - 0.4 in./hr. corresponds to heavy precipitation.
    let intensity: Double

    /// Between 0 and 1 (inclusive) representing the probability of precipitation occurring at the given time.
    let probability: Double

    /// `minutely` data points are always aligned to the top of the minute, `hourly` points to the top of the hour, and `daily` points to midnight of the day, all according to the local time zone.
    let timestamp: Date

}

extension Precipitation: Decodable {

    private enum CodingKeys: String, CodingKey {
        case intensity = "precipIntensity"
        case probability = "precipProbability"
        case time = "time"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        intensity = try values.decode(Double.self, forKey: .intensity)
        probability = try values.decode(Double.self, forKey: .probability)
        timestamp = try values.decodeDateCleverly(forKey: .time)

    }

}
