//
//  Currently.swift
//  Gud Tay
//
//  Created by Zev Eisenberg on 8/14/16.
//  Copyright © 2016 Zev Eisenberg. All rights reserved.
//

struct Currently {

    let precipitation: Precipitation
    let meteorology: Meteorology
    let temperature: Temperature
    let nearestStorm: NearestStorm

}

extension Currently: Decodable {

    init(from decoder: Decoder) throws {
        precipitation = try Precipitation(from: decoder)
        meteorology = try Meteorology(from: decoder)
        temperature = try Temperature(from: decoder)
        nearestStorm = try NearestStorm(from: decoder)
    }

}
