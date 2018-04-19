//
//  Currently.swift
//  Services
//
//  Created by Zev Eisenberg on 8/14/16.
//  Copyright © 2016 Zev Eisenberg. All rights reserved.
//

public struct Currently {

    public let precipitation: Precipitation
    public let meteorology: Meteorology
    public let temperature: Temperature
    public let nearestStorm: NearestStorm

}

extension Currently: Decodable {

    public init(from decoder: Decoder) throws {
        precipitation = try Precipitation(from: decoder)
        meteorology = try Meteorology(from: decoder)
        temperature = try Temperature(from: decoder)
        nearestStorm = try NearestStorm(from: decoder)
    }

}
