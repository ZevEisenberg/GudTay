//
//  Minutely.swift
//  Services
//
//  Created by Zev Eisenberg on 8/14/16.
//  Copyright © 2016 Zev Eisenberg. All rights reserved.
//

public struct Minutely: PrecipitationHaver {

    public let precipitation: WeatherBucket<Precipitation>

}

extension Minutely: Decodable {

    public init(from decoder: Decoder) throws {
        precipitation = try WeatherBucket(from: decoder)
    }

}
