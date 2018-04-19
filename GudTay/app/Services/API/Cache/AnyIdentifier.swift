//
//  AnyIdentifier.swift
//  Services
//
//  Created by Zev Eisenberg on 4/16/18.
//

public protocol AnyIdentifiable {

}

public struct AnyIdentifier: Hashable, Codable {

    let value: String

    init<T>(_ id: Identifier<T>) {
        value = String(describing: T.self) + id.value
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        value = try container.decode(String.self)
    }

}
