//
//  Hourly.swift
//  Services
//
//  Created by Zev Eisenberg on 8/14/16.
//  Copyright © 2016 Zev Eisenberg. All rights reserved.
//

public struct Hourly: PrecipitationHaver, MeteorologyHaver, TemperatureHaver {

    public let precipitation: WeatherBucket<Precipitation>
    public let meteorology: WeatherBucket<Meteorology>
    public let temperature: WeatherBucket<Temperature>

}

extension Hourly: Decodable {

    public init(from decoder: Decoder) throws {
        precipitation = try WeatherBucket(from: decoder)
        meteorology = try WeatherBucket(from: decoder)
        temperature = try WeatherBucket(from: decoder)
    }

}
