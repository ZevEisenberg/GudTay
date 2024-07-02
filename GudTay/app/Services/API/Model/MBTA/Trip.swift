//
//  Trip.swift
//  Services
//
//  Created by Zev Eisenberg on 4/16/18.
//

import JSONAPI

typealias APITrip = ResourceObject<TripDescription, NoMetadata, NoLinks, String>

enum TripDescription: ResourceObjectDescription {
    static var jsonType: String { "trip" }

    struct Attributes: JSONAPI.Attributes {
        let directionId: Attribute<Int>
        let headsign: Attribute<String>
        let name: Attribute<String>
    }

    struct Relationships: JSONAPI.Relationships {
        let route: ToOneRelationship<APIRoute, NoMetadata, NoMetadata, NoLinks>
    }
}

public struct Trip {

    public let id: Tagged<Trip, String>

    public let directionId: Int
    public let headsign: String
    public let name: String

    static func from(_ trip: APITrip) -> Self {
        let attributes = trip.attributes
        return Self(
            id: .init(trip.id.rawValue),
            directionId: attributes.directionId.value,
            headsign: attributes.headsign.value,
            name: attributes.name.value
        )
    }
}
