//
//  Stop.swift
//  Services
//
//  Created by Zev Eisenberg on 4/16/18.
//

public struct Stop {

    public var cache: FlatCache?
    public let id: Identifier<Stop>

    public let latitude: Double
    public let longitude: Double
    public let name: String

}

extension Stop: Entity {

    public enum AttributeKeys: String, CodingKey {
        case latitude
        case longitude
        case name
    }

    public enum RelationshipKeys: CodingKey {
    }

    public init(helper: JSONAPI.DecodingHelper<Stop, AttributeKeys, RelationshipKeys>) throws {
        self.cache = helper.decoder.cache
        self.id = helper.id

        self.latitude = try helper.attribute(forKey: .latitude)
        self.longitude = try helper.attribute(forKey: .longitude)
        self.name = try helper.attribute(forKey: .name)
    }

}
