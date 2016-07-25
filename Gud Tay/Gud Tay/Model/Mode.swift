//
//  Mode.swift
//  Gud Tay
//
//  Created by Zev Eisenberg on 7/20/16.
//
//

struct Mode {

    let type: String
    let name: String // "Subway", "Bus"
    let routes: [Route]

}

extension Mode: JSONRepresentable {

    init(json: JSONObject) throws {
        do {
            type = try json.value(key: "route_type")
            name = try json.value(key: "mode_name")

            if let routesValue: [JSONObject] = try json.optionalValue(key: "route") {
                routes = try Route.objects(from: routesValue)
            } else {
                routes = []
            }
        } catch let error {
            throw error
        }
    }

}

extension Mode: JSONListable { }
