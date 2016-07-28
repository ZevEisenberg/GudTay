//
//  Trip.swift
//  Gud Tay
//
//  Created by Zev Eisenberg on 7/20/16.
//
//

import Foundation.NSDate

struct Trip {

    let identifier: String
    let name: String
    let headsign: String
    let scheduledArrival: Date
    let scheduledDeparture: Date
    let predictedDeparture: Date // ???: is this departure or arrival?
    let predictedSecondsAway: TimeInterval
    let vehicle: Vehicle?

}

extension Trip: JSONRepresentable {

    init(json: JSONObject) throws {
        do {
            identifier = try json.value(key: "trip_id")
            name = try json.value(key: "trip_name")
            headsign = try json.value(key: "trip_headsign")
            scheduledArrival = try json.date(key: "sch_arr_dt")
            scheduledDeparture = try json.date(key: "sch_dep_dt")
            predictedDeparture = try json.date(key: "pre_dt")
            predictedSecondsAway = try json.timeInterval(key: "pre_away")


            if let vehicleJson: JSONObject = try json.optionalValue(key: "vehicle") {
                vehicle = try Vehicle(json: vehicleJson)
            }
            else {
                vehicle = nil
            }
        }
        catch let error {
            throw error
        }
    }

}

extension Trip: JSONListable { }
