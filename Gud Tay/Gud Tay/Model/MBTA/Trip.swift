//
//  Trip.swift
//  Gud Tay
//
//  Created by Zev Eisenberg on 7/20/16.
//
//

import Foundation.NSDate
import JSON

struct Trip {

    let identifier: String
    let name: String
    let headsign: String?
    let scheduledArrival: Date?
    let scheduledDeparture: Date?
    let predictedDeparture: Date // ???: is this departure or arrival?
    let predictedSecondsAway: TimeInterval
    let vehicle: Vehicle?

}

extension Trip: JSON.Representable {

    init(json: JSON.Object) throws {
        scheduledArrival = json.optionalDate(key: "sch_arr_dt")
        scheduledDeparture = json.optionalDate(key: "sch_dep_dt")
        headsign = json.optionalValue(key: "trip_headsign")

        identifier = try json.value(key: "trip_id")
        name = try json.value(key: "trip_name")
        predictedDeparture = try json.date(key: "pre_dt")
        predictedSecondsAway = try json.timeInterval(key: "pre_away")
        if predictedSecondsAway < 0 {
            LogService.add(message: "Got a negative time interval from json: \(json)")
        }

        if let vehicleJson: JSON.Object = json.optionalValue(key: "vehicle") {
            vehicle = try Vehicle(json: vehicleJson)
        }
        else {
            vehicle = nil
        }
    }

}

extension Trip: JSON.Listable { }
