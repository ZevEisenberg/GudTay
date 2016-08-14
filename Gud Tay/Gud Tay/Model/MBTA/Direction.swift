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
        do {
            identifier = try json.value(key: "direction_id")
            name = try json.value(key: "direction_name")

            let tripValue: [JSONObject] = try json.value(key: "trip")
            trips = try Trip.objects(from: tripValue)
        }
        catch let error {
            throw error
        }
    }

}

extension Direction: JSONListable { }
