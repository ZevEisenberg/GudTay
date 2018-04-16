//
//  Temperature.swift
//  Gud Tay
//
//  Created by Zev Eisenberg on 8/14/16.
//  Copyright © 2016 Zev Eisenberg. All rights reserved.
//

struct Temperature: Decodable {

    /// The temperature in degrees Fahrenheit.
    let current: Double

    /// The apparent (or “feels like”) temperature at the given time in degrees Fahrenheit.
    let apparent: Double

    private enum CodingKeys: String, CodingKey {
        case current = "temperature"
        case apparent = "apparentTemperature"
    }

}
