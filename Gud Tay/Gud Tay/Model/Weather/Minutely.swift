//
//  Minutely.swift
//  Gud Tay
//
//  Created by Zev Eisenberg on 8/14/16.
//  Copyright © 2016 Zev Eisenberg. All rights reserved.
//

struct Minutely: PrecipitationHaver {

    let precipitation: WeatherBucket<Precipitation>

}

extension Minutely: JSONRepresentable {

    init(json: JSONObject) throws {
        precipitation = try WeatherBucket(json: json)
    }

}
