//
//  Stop.swift
//  Services
//
//  Created by Zev Eisenberg on 4/16/18.
//

import JSONAPI

typealias APIStop = ResourceObject<StopDescription, NoMetadata, NoLinks, String>

enum StopDescription: ResourceObjectDescription {

    static var jsonType: String { "stop" }

    struct Attributes: JSONAPI.Attributes {
        let id: Attribute<Tagged<Stop, String>>
        let latitude: Attribute<Double>
        let longitude: Attribute<Double>
        let name: Attribute<String>
    }

    typealias Relationships = NoRelationships

}

public struct Stop {

    public let id: Tagged<Stop, String>

    public let latitude: Double
    public let longitude: Double
    public let name: String

    static func from(_ stop: APIStop) -> Self {
        let attributes = stop.attributes
        return Self(
            id: .init(stop.id.rawValue),
            latitude: attributes.latitude.value,
            longitude: attributes.longitude.value,
            name: attributes.name.value
        )
    }

}
