//
//  Mode.swift
//  Gud Tay
//
//  Created by Zev Eisenberg on 7/20/16.
//
//

/// Based on GTFS `route_type` key: <https://developers.google.com/transit/gtfs/reference/routes-file>
enum ModeType: Int, Decodable {

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

extension Mode: Decodable {

    private enum CodingKeys: String, CodingKey {
        case type = "route_type"
        case name = "mode_name"
        case routes = "route"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decode(String.self, forKey: .name)

        let typeString = try values.decode(String.self, forKey: .type)
        guard let typeInt = Int(typeString),
            let type = ModeType(rawValue: typeInt) else {
                throw DecodingError.dataCorruptedError(forKey: .type, in: values, debugDescription: "Malformed value '\(typeString)'")
        }

        self.type = type

        routes = try values.decodeIfPresent([Route].self, forKey: .routes) ?? []
    }

}
