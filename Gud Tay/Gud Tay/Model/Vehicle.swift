//
//  Vehicle.swift
//  Gud Tay
//
//  Created by Zev Eisenberg on 7/20/16.
//
//

import Foundation.NSDate

struct Vehicle {

    let identifier: String
    let location: Coordinate
    let timestamp: Date

}

extension Vehicle: JSONRepresentable {

    init(json: JSONObject) throws {
        do {
            identifier = try json.value(key: "vehicle_id")
            timestamp = try json.date(key: "vehicle_timestamp")
            location = try Coordinate(json: json)
        } catch let error {
            throw error
        }
    }

}
