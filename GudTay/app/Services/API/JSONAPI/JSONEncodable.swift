//
//  JSONEncodable.swift
//  Services
//
//  Created by Zev Eisenberg on 4/16/18.
//

public typealias JSONObject = [String: Any]

public protocol JSONAPIEncodable {

    var jsonEncoded: JSONObject { get }

}

struct ResourceStub<T: Entity> {
    let type = T.apiType
    var attributes: JSONObject?
    var relationships: JSONObject?

    init(attributes: JSONObject? = nil, relationships: JSONObject? = nil) {
        self.attributes = attributes
        self.relationships = relationships
    }
}

extension ResourceStub: JSONAPIEncodable {

    var jsonEncoded: JSONObject {
        [
            "type": type,
            "attributes": attributes,
            "relationships": relationships,
            ].withoutNilValues
    }

}

extension Entity {

    public var jsonEncoded: JSONObject {
        [
            "type": Self.apiType,
            "id": id.value,
        ]
    }

    func jsonEncodedWith(attributes: JSONObject? = nil, relationships: JSONObject? = nil) -> JSONObject {
        [
            "type": Self.apiType,
            "id": id.value,
            "attributes": attributes,
            "relationships": relationships,
            ].withoutNilValues
    }

}

extension Array where Element == JSONAPIEncodable {

    var jsonEncoded: [JSONObject] {
        compactMap { $0.jsonEncoded }
    }

}

extension Array where Element: JSONAPIEncodable {

    var jsonEncoded: [JSONObject] {
        compactMap { $0.jsonEncoded }
    }

}

private extension Dictionary where Key == String, Value == Any? {

    var withoutNilValues: [String: Any] {
        var result: [String: Any] = [:]
        for (dictKey, value) in self {
            if let value = value {
                result[dictKey] = value
            }
        }
        return result
    }

}
