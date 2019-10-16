//
//  Identifier.swift
//  Services
//
//  Created by Zev Eisenberg on 4/16/18.
//

public struct Identifier<T>: Hashable, Codable {

    let value: String

    init(_ value: String) {
        self.value = value
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        value = try container.decode(String.self)
    }

}

extension Identifier: ExpressibleByStringLiteral {
    public init(extendedGraphemeClusterLiteral value: String) {
        self.value = value
    }
    public init(stringLiteral value: String) {
        self.value = value
    }
    public init(unicodeScalarLiteral value: String) {
        self.value = value
    }
}

extension Identifier: CustomStringConvertible {

    public var description: String {
        return value
    }

}

public protocol Identifiable: AnyIdentifiable {

    var id: Identifier<Self> { get }

}

public extension Collection where Element: Identifiable {

    var ids: [Identifier<Element>] {
        return map { $0.id }
    }

}
