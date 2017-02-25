//
//  Route.swift
//  Gud Tay
//
//  Created by Zev Eisenberg on 7/20/16.
//
//

struct Route {

    let identifier: String
    let name: String
    let directions: [Direction]

}

extension Route: JSONRepresentable {

    init(json: JSONObject) throws {
        identifier = try json.value(key: "route_id")
        name = try json.value(key: "route_name")

        let directionsValue: [JSONObject] = try json.value(key: "direction")
        directions = try Direction.objects(from: directionsValue)
    }

}

extension Route: JSONListable { }
