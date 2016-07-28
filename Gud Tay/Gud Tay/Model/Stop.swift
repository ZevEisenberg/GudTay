//
//  Stop.swift
//  Gud Tay
//
//  Created by Zev Eisenberg on 7/20/16.
//
//

struct Stop {

    let identifier: String
    let name: String
    let modes: [Mode]

}

extension Stop: JSONRepresentable {

    init(json: JSONObject) throws {
        do {
            identifier = try json.value(key: "stop_id")
            name = try json.value(key: "stop_name")

            if let modesValue: [JSONObject] = try json.optionalValue(key: "mode") {
                modes = try Mode.objects(from: modesValue)
            }
            else {
                modes = []
            }
        }
        catch let error {
            throw error
        }
    }

}
