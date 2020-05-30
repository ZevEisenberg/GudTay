//
//  Collection+Utilities.swift
//  Utilities
//
//  Created by Zev Eisenberg on 4/16/18.
//

public extension Collection {

    func doesNotContain(where predicate: (Element) throws -> Bool) rethrows -> Bool {
        try !contains(where: predicate)
    }

    func sorted<Property: Comparable>(by keyPath: KeyPath<Element, Property>) -> [Element] {
        sorted(by: { $0[keyPath: keyPath] < $1[keyPath: keyPath] })
    }

}
