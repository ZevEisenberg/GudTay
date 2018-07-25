//
//  Route.swift
//  Services
//
//  Created by Zev Eisenberg on 4/16/18.
//

public struct Route {

    public var cache: FlatCache?
    public let id: Identifier<Route>

    public let colorString: String
    public let mbtaDescription: String
    public let directionNames: [String]
    public let longName: String
    public let shortName: String
    public let textColorString: String
    public let type: Int

}

extension Route: Entity {

    public enum AttributeKeys: String, CodingKey {
        case color
        case description
        case directionNames
        case longName
        case shortName
        case textColor
        case type
    }

    public enum RelationshipKeys: CodingKey {
    }

    public init(helper: JSONAPI.DecodingHelper<Route, AttributeKeys, RelationshipKeys>) throws {
        self.cache = helper.decoder.cache
        self.id = helper.id

        self.colorString = try helper.attribute(forKey: .color)
        self.mbtaDescription = try helper.attribute(forKey: .description)
        self.directionNames = try helper.attribute(forKey: .directionNames)
        self.longName = try helper.attribute(forKey: .longName)
        self.shortName = try helper.attribute(forKey: .shortName)
        self.textColorString = try helper.attribute(forKey: .textColor)
        self.type = try helper.attribute(forKey: .type)
    }

}