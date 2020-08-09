//
//  WIth.swift
//  Utilities
//
//  Created by Zev Eisenberg on 8/9/20.
//

public func with<T>(_ input: T, configuration: (inout T) -> Void) -> T {
    var t = input
    configuration(&t)
    return t
}
