//
//  Direction.swift
//  Gud Tay
//
//  Created by Zev Eisenberg on 7/20/16.
//
//

struct Direction {

    let identifier: String
    let name: String
    let trips: [Trip]

}

extension Direction: JSONRepresentable {

    init(json: JSONObject) throws {
        identifier = try json.value(key: "direction_id")
        name = try json.value(key: "direction_name")

        let tripValue: [JSONObject] = try json.value(key: "trip")
        trips = try Trip.objects(from: tripValue)
    }

}

extension Direction: JSONListable { }
