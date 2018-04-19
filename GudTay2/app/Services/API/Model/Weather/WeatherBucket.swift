//
//  WeatherBucket.swift
//  Services
//
//  Created by Zev Eisenberg on 8/14/16.
//  Copyright © 2016 Zev Eisenberg. All rights reserved.
//

public struct WeatherBucket<WeatherData: Decodable> {

    public let summary: String?
    public let icon: Icon?
    public let data: [WeatherData]

}

extension WeatherBucket: Decodable {

    private enum CodingKeys: CodingKey {
        case summary
        case icon
        case data
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        summary = try values.decodeIfPresent(String.self, forKey: .summary)
        icon = try values.decodeIfPresent(String.self, forKey: .icon).flatMap(Icon.init(rawValue:))
        data = try values.decode([WeatherData].self, forKey: .data)
    }

}
