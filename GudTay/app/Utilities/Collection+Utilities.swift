//
//  Collection+Utilities.swift
//  Utilities
//
//  Created by Zev Eisenberg on 4/16/18.
//

extension Collection {

    public func doesNotContain(where predicate: (Element) throws -> Bool) rethrows -> Bool {
        return try !contains(where: predicate)
    }

    public func containsOnly(where predicate: (Element) throws -> Bool) rethrows -> Bool {
        return try !contains { try !predicate($0) }
    }

}
