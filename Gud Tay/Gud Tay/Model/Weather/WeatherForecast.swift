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

extension WeatherForecast: JSONRepresentable {

    init(json: JSONObject) throws {
        do {
            coordinate = try WeatherCoordinate(json: json)
            timeZone = try TimeZone(identifier: json.value(key: "timezone")) ?? TimeZone.current

            currently = try Currently(json: json.value(key: "currently"))
            minutely = try Minutely(json: json.value(key: "minutely"))
            hourly = try Hourly(json: json.value(key: "hourly"))
            daily = try Daily(json: json.value(key: "daily"))
        }
        catch let error {
            throw error
        }
    }

}
