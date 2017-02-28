//
//  Temperature.swift
//  Gud Tay
//
//  Created by Zev Eisenberg on 8/14/16.
//  Copyright © 2016 Zev Eisenberg. All rights reserved.
//

import JSON

struct Temperature {

    /// The temperature in degrees Fahrenheit.
    let current: Double

    /// The apparent (or “feels like”) temperature at the given time in degrees Fahrenheit.
    let apparent: Double

}

extension Temperature: JSON.Representable {

    init(json: JSON.Object) throws {
        current = try json.value(key: "temperature")
        apparent = try json.value(key: "apparentTemperature")
    }

}

extension Temperature: JSON.Listable { }
