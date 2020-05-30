//
//  Route.swift
//  Services
//
//  Created by Zev Eisenberg on 4/16/18.
//

import JSONAPI

typealias APIRoute = ResourceObject<RouteDescription, NoMetadata, NoLinks, String>

enum RouteDescription: ResourceObjectDescription {
    static var jsonType: String { "route" }

    struct Attributes: JSONAPI.Attributes {
        let colorString: Attribute<String>?
        let mbtaDescription: Attribute<String>
        let directionNames: Attribute<[String]>
        let longName: Attribute<String>
        let shortName: Attribute<String>
        let textColorString: Attribute<String>?
        let type: Attribute<Int>

        enum CodingKeys: String, CodingKey {
            case colorString
            case mbtaDescription = "description"
            case directionNames
            case longName
            case shortName
            case textColorString
            case type
        }
    }

    typealias Relationships = NoRelationships
}

public struct Route {

    public let id: Tagged<Route, String>

    public let colorString: String?
    public let mbtaDescription: String
    public let directionNames: [String]
    public let longName: String
    public let shortName: String
    public let textColorString: String?
    public let type: Int

    static func from(_ route: APIRoute) -> Self {
        let attributes = route.attributes
        return Self(
            id: .init(route.id.rawValue),
            colorString: attributes.colorString?.value,
            mbtaDescription: attributes.mbtaDescription.value,
            directionNames: attributes.directionNames.value,
            longName: attributes.longName.value,
            shortName: attributes.shortName.value,
            textColorString: attributes.textColorString?.value,
            type: attributes.type.value
        )
    }

}
