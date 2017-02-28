//
//  Stop.swift
//  Gud Tay
//
//  Created by Zev Eisenberg on 7/20/16.
//
//

import JSON

struct Stop {

    let identifier: String
    let name: String
    let modes: [Mode]

}

extension Stop: JSON.Representable {

    init(json: JSON.Object) throws {
        identifier = try json.value(key: "stop_id")
        name = try json.value(key: "stop_name")

        if let modesValue: [JSON.Object] = json.optionalValue(key: "mode") {
            modes = try Mode.objects(from: modesValue)
        }
        else {
            modes = []
        }
    }

}
