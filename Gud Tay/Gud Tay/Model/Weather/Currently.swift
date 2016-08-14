//
//  Currently.swift
//  Gud Tay
//
//  Created by Zev Eisenberg on 8/14/16.
//  Copyright © 2016 Zev Eisenberg. All rights reserved.
//

struct Currently {

    let precipitation: Precipitation
    let meteorology: Meteorology
    let temperature: Temperature
    let nearestStorm: NearestStorm

}

extension Currently: JSONRepresentable {

    init(json: JSONObject) throws {
        do {
            precipitation = try Precipitation(json: json)
            meteorology = try Meteorology(json: json)
            temperature = try Temperature(json: json)
            nearestStorm = try NearestStorm(json: json)
        }
        catch let error {
            throw error
        }
    }

}
