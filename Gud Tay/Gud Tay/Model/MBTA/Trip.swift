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
    let headsign: String?
    let scheduledArrival: Date?
    let scheduledDeparture: Date?
    let predictedDeparture: Date // ???: is this departure or arrival?
    let predictedSecondsAway: TimeInterval
    let vehicle: Vehicle?

}

extension Trip: Decodable {

    private enum CodingKeys: String, CodingKey {
        case scheduledArrival = "sch_arr_dt"
        case scheduledDeparture = "sch_dep_dt"
        case headsign = "trip_headsign"
        case tripFooBarId = "trip_id"
        case name = "trip_name"
        case predictedDeparture = "pre_dt"
        case predictedSecondsAway = "pre_away"
        case vehicle = "vehicle"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        identifier = try values.decode(String.self, forKey: .tripFooBarId)
        name = try values.decode(String.self, forKey: .name)
        headsign = try values.decodeIfPresent(String.self, forKey: .headsign)
        scheduledArrival = values.decodeDateCleverlyIfPresent(forKey: .scheduledArrival)
        scheduledDeparture = values.decodeDateCleverlyIfPresent(forKey: .scheduledDeparture)
        predictedDeparture = try values.decodeDateCleverly(forKey: .predictedDeparture)
        vehicle = try values.decodeIfPresent(Vehicle.self, forKey: .vehicle)

        if let predictedSecondsString = (try? values.decodeIfPresent(String.self, forKey: .predictedSecondsAway)).flatMap({ $0 }),
            let predictedSecondsInterval = TimeInterval(predictedSecondsString) {
            predictedSecondsAway = predictedSecondsInterval
        }
        else {
            predictedSecondsAway = try values.decode(TimeInterval.self, forKey: .predictedSecondsAway)
        }
    }
}
