//
//  Temperature.swift
//  Services
//
//  Created by Zev Eisenberg on 8/14/16.
//  Copyright © 2016 Zev Eisenberg. All rights reserved.
//

public struct Temperature: Decodable {

    /// The temperature in degrees Fahrenheit.
    public let current: Double

    /// The apparent (or “feels like”) temperature at the given time in degrees Fahrenheit.
    public let apparent: Double

    private enum CodingKeys: String, CodingKey {
        case current = "temperature"
        case apparent = "apparentTemperature"
    }

}
