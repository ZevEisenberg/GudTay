//
//  Mode.swift
//  Gud Tay
//
//  Created by Zev Eisenberg on 7/20/16.
//
//

/// Based on GTFS `route_type` key: <https://developers.google.com/transit/gtfs/reference/routes-file>
enum ModeType: Int {

    /// Tram, Streetcar, Light rail. Any light rail or street level system within a metropolitan area.
    case tramOrStreetcar = 0

    /// Subway, Metro. Any underground rail system within a metropolitan area.
    case subway = 1

    /// Rail. Used for intercity or long-distance travel.
    case rail = 2

    /// Bus. Used for short- and long-distance bus routes.
    case bus = 3

    /// Ferry. Used for short- and long-distance boat service.
    case ferry = 4

    /// Cable car. Used for street-level cable cars where the cable runs beneath the car.
    case cableCar = 5

    /// Gondola, Suspended cable car. Typically used for aerial cable cars where the car is suspended from the cable.
    case gondola = 6

    /// Funicular. Any rail system designed for steep inclines.
    case funicular = 7

}

struct Mode {

    let type: ModeType
    let name: String // "Subway", "Bus"
    let routes: [Route]

}

extension Mode: JSONRepresentable {

    init(json: JSONObject) throws {
        do {
            name = try json.value(key: "mode_name")

            let typeString: String = try json.value(key: "route_type")
            guard let typeInt = Int(typeString),
                let type = ModeType(rawValue: typeInt) else {
                throw JSONError.malformedValue(key: "route_type", value: typeString)
            }

            self.type = type

            if let routesValue: [JSONObject] = try json.optionalValue(key: "route") {
                routes = try Route.objects(from: routesValue)
            }
            else {
                routes = []
            }
        }
        catch let error {
            throw error
        }
    }

}

extension Mode: JSONListable { }
