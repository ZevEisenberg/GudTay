//
//  Daily.swift
//  Gud Tay
//
//  Created by Zev Eisenberg on 8/14/16.
//  Copyright © 2016 Zev Eisenberg. All rights reserved.
//

struct Daily: MeteorologyHaver, AlmanacHaver {

    let meteorology: WeatherBucket<Meteorology>
    let almanac: WeatherBucket<Almanac>

}

extension Daily: Decodable {

    init(from decoder: Decoder) throws {
        meteorology = try WeatherBucket(from: decoder)
        almanac = try WeatherBucket(from: decoder)
    }

}
