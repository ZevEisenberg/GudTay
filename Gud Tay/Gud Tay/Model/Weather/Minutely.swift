//
//  Minutely.swift
//  Gud Tay
//
//  Created by Zev Eisenberg on 8/14/16.
//  Copyright © 2016 Zev Eisenberg. All rights reserved.
//

import JSON

struct Minutely: PrecipitationHaver {

    let precipitation: WeatherBucket<Precipitation>

}

extension Minutely: JSON.Representable {

    init(json: JSON.Object) throws {
        precipitation = try WeatherBucket(json: json)
    }

}
