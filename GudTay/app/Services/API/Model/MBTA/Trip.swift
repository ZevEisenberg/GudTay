//
//  Trip.swift
//  Services
//
//  Created by Zev Eisenberg on 4/16/18.
//

public struct Trip {

    public var cache: FlatCache?
    public let id: Identifier<Trip>

    public let directionId: Int
    public let headsign: String
    public let name: String

    let routeId: Identifier<Route>

}

public extension Trip {

    var route: Route {
        cache!.get(id: routeId)!
    }

}

extension Trip: Entity {

    public enum AttributeKeys: String, CodingKey {
        case directionId
        case headsign
        case name
    }

    public enum RelationshipKeys: String, CodingKey {
        case route
    }

    public init(helper: JSONAPI.DecodingHelper<Trip, AttributeKeys, RelationshipKeys>) throws {
        self.cache = helper.decoder.cache
        self.id = helper.id

        self.directionId = try helper.attribute(forKey: .directionId)
        self.headsign = try helper.attribute(forKey: .headsign)
        self.name = try helper.attribute(forKey: .name)

        self.routeId = try helper.relationship(for: .route)
    }

}
