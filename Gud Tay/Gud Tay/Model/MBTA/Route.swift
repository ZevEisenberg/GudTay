//
//  Route.swift
//  Gud Tay
//
//  Created by Zev Eisenberg on 7/20/16.
//
//

import JSON

struct Route {

    let identifier: String
    let name: String
    let directions: [Direction]

}

extension Route: JSON.Representable {

    init(json: JSON.Object) throws {
        identifier = try json.value(key: "route_id")
        name = try json.value(key: "route_name")

        let directionsValue: [JSON.Object] = try json.value(key: "direction")
        directions = try Direction.objects(from: directionsValue)
    }

}

extension Route: JSON.Listable { }
