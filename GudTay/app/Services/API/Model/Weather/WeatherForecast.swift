//
//  WeatherForecast.swift
//  Services
//
//  Created by Zev Eisenberg on 8/7/16.
//  Copyright © 2016 Zev Eisenberg. All rights reserved.
//

import Foundation.NSTimeZone

public struct WeatherForecast {

    public let coordinate: WeatherCoordinate
    public let timeZone: TimeZone

    public let currently: Currently
    public let minutely: Minutely
    public let hourly: Hourly
    public let daily: Daily

}

extension WeatherForecast: Decodable {

    private enum CodingKeys: String, CodingKey {
        case timeZone = "timezone"
        case currently
        case minutely
        case hourly
        case daily
    }

    public init(from decoder: Decoder) throws {
        coordinate = try WeatherCoordinate(from: decoder)

        let values = try decoder.container(keyedBy: CodingKeys.self)

        timeZone = TimeZone(identifier: try values.decode(String.self, forKey: .timeZone)) ?? .current

        currently = try values.decode(Currently.self, forKey: .currently)
        minutely = try values.decode(Minutely.self, forKey: .minutely)
        hourly = try values.decode(Hourly.self, forKey: .hourly)
        daily = try values.decode(Daily.self, forKey: .daily)
    }

}
