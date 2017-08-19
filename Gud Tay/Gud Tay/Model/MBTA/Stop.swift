//
//  Stop.swift
//  Gud Tay
//
//  Created by Zev Eisenberg on 7/20/16.
//
//

struct Stop: Decodable {

    let identifier: String
    let name: String
    let modes: [Mode]

    private enum CodingKeys: String, CodingKey {
        case identifier = "stop_id"
        case name = "stop_name"
        case modes = "mode"
    }

}
