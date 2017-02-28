//
//  Vehicle.swift
//  Gud Tay
//
//  Created by Zev Eisenberg on 7/20/16.
//
//

import JSON

import Foundation.NSDate

struct Vehicle {

    let identifier: String
    let location: Coordinate
    let timestamp: Date

}

extension Vehicle: JSON.Representable {

    init(json: JSON.Object) throws {
        identifier = try json.value(key: "vehicle_id")
        timestamp = try json.date(key: "vehicle_timestamp")
        location = try Coordinate(json: json)
    }

}
