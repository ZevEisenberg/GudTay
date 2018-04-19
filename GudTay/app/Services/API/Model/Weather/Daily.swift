//
//  Daily.swift
//  Services
//
//  Created by Zev Eisenberg on 8/14/16.
//  Copyright © 2016 Zev Eisenberg. All rights reserved.
//

public struct Daily: MeteorologyHaver, AlmanacHaver {

    public let meteorology: WeatherBucket<Meteorology>
    public let almanac: WeatherBucket<Almanac>

}

extension Daily: Decodable {

    public init(from decoder: Decoder) throws {
        meteorology = try WeatherBucket(from: decoder)
        almanac = try WeatherBucket(from: decoder)
    }

}
