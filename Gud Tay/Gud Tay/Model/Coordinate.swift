//
//  Coordinate.swift
//  Gud Tay
//
//  Created by Zev Eisenberg on 7/23/16.
//
//

struct Coordinate {

    let lat: Double
    let lon: Double
    let bearing: Int

}

extension Coordinate: JSONRepresentable {

    init(json: JSONObject) throws {
        guard let latString = json["vehicle_lat"] as? String else {
            throw JSONError.malformedOrMissingKey("vehicle_lat")
        }

        guard let lonString = json["vehicle_lon"] as? String else {
            throw JSONError.malformedOrMissingKey("vehicle_lon")
        }

        guard let bearingString = json["vehicle_bearing"] as? String else {
            throw JSONError.malformedOrMissingKey("vehicle_bearing")
        }

        guard let lat = Double(latString) else {
            throw JSONError.malformedValue(key: "vehicle_lat", value: latString)
        }

        guard let lon = Double(lonString) else {
            throw JSONError.malformedValue(key: "vehicle_lon", value: lonString)
        }

        guard let bearing = Int(bearingString) else {
            throw JSONError.malformedValue(key: "vehicle_bearing", value: bearingString)
        }

        self.lat = lat
        self.lon = lon
        self.bearing = bearing
    }

}
