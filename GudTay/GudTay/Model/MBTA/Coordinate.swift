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

extension Coordinate: Decodable {

    private enum CodingKeys: String, CodingKey {
        case lat = "vehicle_lat"
        case lon = "vehicle_lon"
        case bearing = "vehicle_bearing"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        let latString = try values.decode(String.self, forKey: .lat)
        let lonString = try values.decode(String.self, forKey: .lon)
        let bearingString = try values.decode(String.self, forKey: .bearing)

        guard let lat = Double(latString) else {
            throw DecodingError.dataCorruptedError(forKey: .lat, in: values, debugDescription: "Expected string convertible to \(Double.self), but got \'(latString)'")
        }

        guard let lon = Double(lonString) else {
            throw DecodingError.dataCorruptedError(forKey: .lon, in: values, debugDescription: "Expected string convertible to \(Double.self), but got \'(lonString)'")
        }

        guard let bearing = Int(bearingString) else {
            throw DecodingError.dataCorruptedError(forKey: .bearing, in: values, debugDescription: "Expected string convertible to \(Int.self), but got \'(bearingString)'")
        }

        self.lat = lat
        self.lon = lon
        self.bearing = bearing
    }

}
