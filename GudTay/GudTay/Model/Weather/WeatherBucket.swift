//
//  WeatherBucket.swift
//  Gud Tay
//
//  Created by Zev Eisenberg on 8/14/16.
//  Copyright © 2016 Zev Eisenberg. All rights reserved.
//

struct WeatherBucket<WeatherData: Decodable> {

    let summary: String?
    let icon: Icon?
    let data: [WeatherData]

}

extension WeatherBucket: Decodable {

    private enum CodingKeys: String, CodingKey {
        case summary = "summary"
        case icon = "icon"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        summary = try values.decodeIfPresent(String.self, forKey: .summary)
        icon = try values.decodeIfPresent(String.self, forKey: .icon).flatMap(Icon.init(rawValue:))
        data = try values.decode([WeatherData].self, forKey: .data)
    }

}
