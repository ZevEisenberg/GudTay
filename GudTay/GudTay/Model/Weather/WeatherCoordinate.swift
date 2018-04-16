//
//  WeatherCoordinate.swift
//  Gud Tay
//
//  Created by Zev Eisenberg on 8/14/16.
//  Copyright © 2016 Zev Eisenberg. All rights reserved.
//

struct WeatherCoordinate: Decodable {

    let lat: Double
    let lon: Double

    private enum CodingKeys: String, CodingKey {
        case lat = "latitude"
        case lon = "longitude"
    }

}
