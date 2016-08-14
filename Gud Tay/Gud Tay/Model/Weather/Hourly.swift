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

extension Hourly: JSONRepresentable {

    init(json: JSONObject) throws {
        do {
            precipitation = try WeatherBucket(json: json)
            meteorology = try WeatherBucket(json: json)
            temperature = try WeatherBucket(json: json)
        }
        catch let error {
            throw error
        }
    }

}
