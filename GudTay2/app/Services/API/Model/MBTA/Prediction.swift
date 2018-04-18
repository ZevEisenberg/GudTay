//
//  Prediction.swift
//  Services
//
//  Created by Zev Eisenberg on 4/17/18.
//

public struct Prediction {

    public var cache: FlatCache?
    public let id: Identifier<Prediction>

    public let arrivalTime: Date
    public let departureTime: Date
    public let directionId: Int
    public let status: String? // "2 stops away"
    public let stopSequence: Int
    public let track: String?

    let routeId: Identifier<Route>
    let stopId: Identifier<Stop>
    let tripId: Identifier<Trip>
    // TODO: vehicle?

}

extension Prediction {

    public var route: Route {
        return cache!.get(id: routeId)!
    }

    public var stop: Stop {
        return cache!.get(id: stopId)!
    }

    public var trip: Trip {
        return cache!.get(id: tripId)!
    }

}

extension Prediction: Entity {

    public enum AttributeKeys: CodingKey {
        case arrivalTime
        case departureTime
        case directionId
        case status
        case stopSequence
        case track
    }

    public enum RelationshipKeys: CodingKey {
        case route
        case stop
        case trip
    }

    public init(helper: JSONAPI.DecodingHelper<Prediction, AttributeKeys, RelationshipKeys>) throws {
        self.cache = helper.decoder.cache
        self.id = helper.id

        self.arrivalTime = try helper.attribute(forKey: .arrivalTime)
        self.departureTime = try helper.attribute(forKey: .departureTime)
        self.directionId = try helper.attribute(forKey: .directionId)
        self.status = try helper.attribute(forKey: .status)
        self.stopSequence = try helper.attribute(forKey: .stopSequence)
        self.track = try helper.attribute(forKey: .track)

        self.routeId = try helper.relationship(for: .route)
        self.stopId = try helper.relationship(for: .stop)
        self.tripId = try helper.relationship(for: .trip)
    }

}
