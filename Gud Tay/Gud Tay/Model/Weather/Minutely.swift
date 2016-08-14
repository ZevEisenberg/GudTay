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
        do {
            precipitation = try WeatherBucket(json: json)
        }
        catch let error {
            throw error
        }
    }

}
