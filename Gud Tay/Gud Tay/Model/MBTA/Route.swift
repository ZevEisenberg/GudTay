//
//  Route.swift
//  Gud Tay
//
//  Created by Zev Eisenberg on 7/20/16.
//
//

struct Route: Decodable {

    let identifier: String
    let name: String
    let directions: [Direction]

    private enum CodingKeys: String, CodingKey {
        case identifier = "route_id"
        case name = "route_name"
        case directions = "direction"
    }

}
