//
//  KeyedDecodingContainer+Utilities.swift
//  Gud Tay
//
//  Created by Zev Eisenberg on 8/18/17.
//  Copyright © 2017 Zev Eisenberg. All rights reserved.
//

import Foundation.NSDate

extension KeyedDecodingContainer {

    func decodeDateCleverly(forKey key: Key) throws -> Date {
        var secondsSinceEpoch: TimeInterval

        if let stringValue = (try? decodeIfPresent(String.self, forKey: key)).flatMap({ $0 }) { // flatMap to unwrap double optional
            guard let seconds = TimeInterval(stringValue) else {
                throw DecodingError.dataCorruptedError(forKey: key, in: self, debugDescription: "Expected a value convertible to a \(TimeInterval.self), but got \(stringValue)")
            }
            secondsSinceEpoch = seconds
        }
        else if let intervalValue = (try? decodeIfPresent(TimeInterval.self, forKey: key)).flatMap({ $0 }) {
            secondsSinceEpoch = intervalValue
        }
        else {
            throw DecodingError.dataCorruptedError(forKey: key, in: self, debugDescription: "Expected value convertible to a time interval or string")
        }

        return Date(timeIntervalSince1970: secondsSinceEpoch)
    }

    func decodeDateCleverlyIfPresent(forKey key: Key) -> Date? {
        return contains(key) ? (try? decodeDateCleverly(forKey: key)) : nil
    }

}
