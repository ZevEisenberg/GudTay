//
//  WeatherForecast.swift
//  Gud Tay
//
//  Created by Zev Eisenberg on 8/7/16.
//  Copyright © 2016 Zev Eisenberg. All rights reserved.
//

import Foundation.NSTimeZone

struct WeatherForecast {

    let coordinate: WeatherCoordinate
    let timeZone: TimeZone

    let currently: Currently
    let minutely: Minutely
    let hourly: Hourly
    let daily: Daily

}

extension WeatherForecast: Decodable {

    private enum CodingKeys: String, CodingKey {
        case timeZone = "timezone"
        case currently = "currently"
        case minutely = "minutely"
        case hourly = "hourly"
        case daily = "daily"
    }

    init(from decoder: Decoder) throws {
        coordinate = try WeatherCoordinate(from: decoder)

        let values = try decoder.container(keyedBy: CodingKeys.self)

        timeZone = TimeZone(identifier: try values.decode(String.self, forKey: .timeZone)) ?? .current

        currently = try values.decode(Currently.self, forKey: .currently)
        minutely = try values.decode(Minutely.self, forKey: .minutely)
        hourly = try values.decode(Hourly.self, forKey: .hourly)
        daily = try values.decode(Daily.self, forKey: .daily)
    }

}
