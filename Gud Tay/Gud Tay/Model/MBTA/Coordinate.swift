//
//  Coordinate.swift
//  Gud Tay
//
//  Created by Zev Eisenberg on 7/23/16.
//
//

import JSON

struct Coordinate {

    let lat: Double
    let lon: Double
    let bearing: Int

}

extension Coordinate: JSON.Representable {

    init(json: JSON.Object) throws {
        guard let latString = json["vehicle_lat"] as? String else {
            throw JSONError.malformedOrMissingKey(key: "vehicle_lat", parent: json)
        }

        guard let lonString = json["vehicle_lon"] as? String else {
            throw JSONError.malformedOrMissingKey(key: "vehicle_lon", parent: json)
        }

        guard let bearingString = json["vehicle_bearing"] as? String else {
            throw JSONError.malformedOrMissingKey(key: "vehicle_bearing", parent: json)
        }

        guard let lat = Double(latString) else {
            throw JSONError.malformedValue(key: "vehicle_lat", value: latString, parent: json)
        }

        guard let lon = Double(lonString) else {
            throw JSONError.malformedValue(key: "vehicle_lon", value: lonString, parent: json)
        }

        guard let bearing = Int(bearingString) else {
            throw JSONError.malformedValue(key: "vehicle_bearing", value: bearingString, parent: json)
        }

        self.lat = lat
        self.lon = lon
        self.bearing = bearing
    }

}
