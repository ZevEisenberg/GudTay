//
//  Direction.swift
//  Gud Tay
//
//  Created by Zev Eisenberg on 7/20/16.
//
//

import JSON

struct Direction {

    let identifier: String
    let name: String
    let trips: [Trip]

}

extension Direction: JSON.Representable {

    init(json: JSON.Object) throws {
        identifier = try json.value(key: "direction_id")
        name = try json.value(key: "direction_name")

        let tripValue: [JSON.Object] = try json.value(key: "trip")
        trips = try Trip.objects(from: tripValue)
    }

}

extension Direction: JSON.Listable { }
