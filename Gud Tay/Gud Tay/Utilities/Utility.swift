//
//  Utility.swift
//  Gud Tay
//
//  Created by Zev Eisenberg on 8/18/16.
//  Copyright © 2016 Zev Eisenberg. All rights reserved.
//

/**
 *  Casts object as the given type. On failure, logs an error and terminates.
 */

@inline(__always) func forceCast<T>(_ value: Any, as type: T.Type) -> T {
    // There is weirdness with collection types (array, dictionary, etc.),
    // where they need to be first cast as AnyObject before they can be downcast
    guard let typedValue = value as? T else {
        preconditionFailure("Expected object of type \(T.self), got \(type(of: value)).")
    }

    return typedValue
}
