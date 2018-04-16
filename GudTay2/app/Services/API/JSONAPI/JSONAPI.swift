//
//  JSONAPI.swift
//  Services
//
//  Created by Zev Eisenberg on 4/16/18.
//

public enum JSONAPI {
    public typealias ResourceType = JSONAPIResourceType

    struct Resource: Decodable {
        let type: String
        let id: AnyIdentifier
    }

    struct Errors: Decodable {
        let errors: [Error]
    }

    public struct Error: Swift.Error, Decodable {
        public let title: String
        public let status: Int
        public let id: String
    }

    enum ResponseKeys: String, CodingKey {
        case data
        case included
    }

    enum ResourceKeys: String, CodingKey {
        case id
        case attributes
        case relationships
    }

    static func decodeIncluded(from container: KeyedDecodingContainer<JSONAPI.ResponseKeys>) throws -> [AnyIdentifiable] {
        guard let resources = try container.decodeIfPresent([JSONAPI.Resource].self, forKey: .included) else {
            return []
        }
        let includedContainer = try container.nestedUnkeyedContainer(forKey: .included)

        let included = try decode(resources: resources, from: includedContainer)
        return included
    }

    public struct DecodingHelper<T, AttributeKeys: CodingKey, RelationshipKeys: CodingKey> {

        let id: Identifier<T>
        let decoder: Decoder
        private let attributes: KeyedDecodingContainer<AttributeKeys>
        private let relationships: KeyedDecodingContainer<RelationshipKeys>

        init(id: Identifier<T>, decoder: Decoder, attributes: KeyedDecodingContainer<AttributeKeys>, relationships: KeyedDecodingContainer<RelationshipKeys>) {
            self.id = id
            self.decoder = decoder
            self.attributes = attributes
            self.relationships = relationships
        }

        func attribute<T: Decodable>(_ type: T.Type = T.self, forKey key: AttributeKeys) throws -> T {
            return try attributes.decode(T.self, forKey: key)
        }

        func relationship<U: Identifiable>(for key: RelationshipKeys) throws -> Set<Identifier<U>> {
            let container = try relationships.nestedContainer(keyedBy: JSONAPI.ResponseKeys.self, forKey: key)
            let resources = try container.decode([JSONAPI.Resource].self, forKey: .data)
            return Set(resources.map { Identifier<U>($0.id.value) })
        }

        func relationship<U: Identifiable>(for key: RelationshipKeys) throws -> [Identifier<U>] {
            let container = try relationships.nestedContainer(keyedBy: JSONAPI.ResponseKeys.self, forKey: key)
            return try container.decode([JSONAPI.Resource].self, forKey: .data).map { Identifier<U>($0.id.value) }
        }

        func relationship<U: Identifiable>(for key: RelationshipKeys) throws -> Identifier<U> {
            let container = try relationships.nestedContainer(keyedBy: JSONAPI.ResponseKeys.self, forKey: key)
            let resource = try container.decode(JSONAPI.Resource.self, forKey: .data)
            return Identifier<U>(resource.id.value)
        }

        func relationshipIfPresent<U: Identifiable>(for key: RelationshipKeys) -> [Identifier<U>] {
            do {
                return try relationship(for: key)
            }
            catch {
                return []
            }
        }

        func relationshipIfPresent<U: Identifiable>(for key: RelationshipKeys) -> Identifier<U>? {
            do {
                return try relationship(for: key)
            }
            catch {
                return nil
            }
        }

    }

}

public protocol JSONAPIResourceType: Identifiable {

    static var apiType: String { get }

}

public protocol JSONAPIDecodable: JSONAPI.ResourceType, Decodable {

    associatedtype AttributeKeys: CodingKey
    associatedtype RelationshipKeys: CodingKey

    init(helper: JSONAPI.DecodingHelper<Self, AttributeKeys, RelationshipKeys>) throws
}

extension JSONAPIDecodable {

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: JSONAPI.ResourceKeys.self)
        let anyId = try values.decode(AnyIdentifier.self, forKey: .id)
        let attributes = try values.nestedContainer(keyedBy: AttributeKeys.self, forKey: .attributes)
        let relationships = try values.nestedContainer(keyedBy: RelationshipKeys.self, forKey: .relationships)
        let id = Identifier<Self>(anyId.value)
        try self.init(helper: JSONAPI.DecodingHelper(id: id, decoder: decoder, attributes: attributes, relationships: relationships))
        decoder.cache!.set(self)
    }
}
