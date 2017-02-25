//
//  WeatherBucket.swift
//  Gud Tay
//
//  Created by Zev Eisenberg on 8/14/16.
//  Copyright © 2016 Zev Eisenberg. All rights reserved.
//

struct WeatherBucket<WeatherData> where WeatherData: JSONListable {

    let summary: String?
    let icon: Icon?
    let data: [WeatherData]

}

extension WeatherBucket: JSONRepresentable {

    init(json: JSONObject) throws {
        summary = json.optionalValue(key: "summary")
        icon = json.optionalValue(key: "icon").flatMap { Icon(rawValue: $0) }

        data = try WeatherData.objects(from: json.value(key: "data"))
    }

}
