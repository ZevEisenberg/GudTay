//
//  Daily.swift
//  Gud Tay
//
//  Created by Zev Eisenberg on 8/14/16.
//  Copyright © 2016 Zev Eisenberg. All rights reserved.
//

import JSON

struct Daily: MeteorologyHaver, AlmanacHaver {

    let meteorology: WeatherBucket<Meteorology>
    let almanac: WeatherBucket<Almanac>

}

extension Daily: JSON.Representable {

    init(json: JSON.Object) throws {
        meteorology = try WeatherBucket(json: json)
        almanac = try WeatherBucket(json: json)
    }

}
