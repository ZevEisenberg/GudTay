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

extension Vehicle: Decodable {

    private enum CodingKeys: String, CodingKey {
        case identifier = "vehicle_id"
        case timestamp = "vehicle_timestamp"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        identifier = try values.decode(String.self, forKey: .identifier)
        timestamp = try values.decodeDateCleverly(forKey: .timestamp)
        location = try Coordinate(from: decoder)
    }

}
