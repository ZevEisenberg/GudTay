//
//  APIEndpoint+Codable.swift
//  Services
//
//  Created by Zev Eisenberg on 4/16/18.
//

import Then

extension JSONDecoder: Then {}
extension JSONEncoder: Then {}

extension JSONDecoder {

    var cache: FlatCache? {
        get {
            return userInfo[cacheKey] as? FlatCache
        }
        set {
            userInfo[cacheKey] = newValue
        }
    }
}

extension Decoder {

    var cache: FlatCache? {
        return userInfo[cacheKey] as? FlatCache
    }
}

// This can not go in the `Decoder` type because it is generic.
private let cacheKey: CodingUserInfoKey = CodingUserInfoKey(rawValue: "com.zeveisenberg.flatCache.cacheKey")!
