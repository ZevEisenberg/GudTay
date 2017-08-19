//
//  Direction.swift
//  Gud Tay
//
//  Created by Zev Eisenberg on 7/20/16.
//
//

struct Direction: Decodable {

    let identifier: String
    let name: String
    let trips: [Trip]

    private enum CodingKeys: String, CodingKey {
        case identifier = "direction_id"
        case name = "direction_name"
        case trips = "trip"
    }

}
