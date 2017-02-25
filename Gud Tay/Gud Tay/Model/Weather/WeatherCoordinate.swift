//
//  WeatherCoordinate.swift
//  Gud Tay
//
//  Created by Zev Eisenberg on 8/14/16.
//  Copyright © 2016 Zev Eisenberg. All rights reserved.
//

struct WeatherCoordinate {

    let lat: Double
    let lon: Double

}

extension WeatherCoordinate: JSONRepresentable {

    init(json: JSONObject) throws {
        lat = try json.value(key: "latitude")
        lon = try json.value(key: "longitude")
    }

}
