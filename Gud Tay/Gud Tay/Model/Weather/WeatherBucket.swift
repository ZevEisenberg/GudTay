//
//  WeatherBucket.swift
//  Gud Tay
//
//  Created by Zev Eisenberg on 8/14/16.
//  Copyright © 2016 Zev Eisenberg. All rights reserved.
//

struct WeatherBucket<WeatherData> where WeatherData: JSONListable {

    let summary: String
    let icon: Icon?
    let data: [WeatherData]

}

extension WeatherBucket: JSONRepresentable {

    init(json: JSONObject) throws {
        do {
            summary = try json.value(key: "summary")
            icon = try Icon(rawValue: json.value(key: "icon"))
            data = try WeatherData.objects(from: json.value(key: "data"))
        }
        catch let error {
            throw error
        }
    }

}
