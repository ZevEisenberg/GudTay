//
//  Hourly.swift
//  Gud Tay
//
//  Created by Zev Eisenberg on 8/14/16.
//  Copyright © 2016 Zev Eisenberg. All rights reserved.
//

struct Hourly: PrecipitationHaver, MeteorologyHaver, TemperatureHaver {

    let precipitation: WeatherBucket<Precipitation>
    let meteorology: WeatherBucket<Meteorology>
    let temperature: WeatherBucket<Temperature>

}

extension Hourly: Decodable {

    init(from decoder: Decoder) throws {
        precipitation = try WeatherBucket(from: decoder)
        meteorology = try WeatherBucket(from: decoder)
        temperature = try WeatherBucket(from: decoder)
    }

}
