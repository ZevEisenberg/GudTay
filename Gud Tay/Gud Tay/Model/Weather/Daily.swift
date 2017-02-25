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

extension Daily: JSONRepresentable {

    init(json: JSONObject) throws {
        meteorology = try WeatherBucket(json: json)
        almanac = try WeatherBucket(json: json)
    }

}
