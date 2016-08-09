//
//  JSONRepresentable.swift
//  Gud Tay
//
//  Created by Zev Eisenberg on 7/23/16.
//
//

import Foundation.NSDate

typealias JSONObject = [String: AnyObject]

enum JSONError: Error {

    case generic
    case malformedOrMissingKey(key: String, parent: Any)
    case malformedValue(key: String, value: Any?, parent: Any)

}

extension Dictionary {

    func value<ReturnType>(key: Key) throws -> ReturnType {
        guard let value = self[key] as? ReturnType else {
            if let key = key as? String {
                throw JSONError.malformedOrMissingKey(key: key, parent: self)
            }
            else {
                throw JSONError.generic
            }
        }
        return value
    }

    func optionalValue<ReturnType>(key: Key) throws -> ReturnType? {
        guard let value = self[key] else {
            return nil
        }

        guard let typedValue = value as? ReturnType else {
            if let key = key as? String {
                throw JSONError.malformedOrMissingKey(key: key, parent: self)
            }
            else {
                throw JSONError.generic
            }
        }
        return typedValue
    }

    func date(key: Key) throws -> Date {
        guard let dateString = self[key] as? String else {
            if let key = key as? String {
                throw JSONError.malformedOrMissingKey(key: key, parent: self)
            }
            else {
                throw JSONError.generic
            }
        }

        guard let secondsSinceEpoch = TimeInterval(dateString) else {
            if let key = key as? String {
                throw JSONError.malformedValue(key: key, value: dateString, parent: self)
            }
            else {
                throw JSONError.generic
            }
        }

        return Date(timeIntervalSince1970: secondsSinceEpoch)
    }

    func timeInterval(key: Key) throws -> TimeInterval {
        guard let intervalString = self[key] as? String else {
            if let key = key as? String {
                throw JSONError.malformedOrMissingKey(key: key, parent: self)
            }
            else {
                throw JSONError.generic
            }
        }

        guard let interval = TimeInterval(intervalString) else {
            if let key = key as? String {
                throw JSONError.malformedValue(key: key, value: intervalString, parent: self)
            }
            else {
                throw JSONError.generic
            }
        }

        return interval
    }

}

protocol JSONRepresentable {

    init(json: JSONObject) throws

}

protocol JSONListable: JSONRepresentable {

    static func objects(from: [JSONObject]) throws -> [Self]

}

extension JSONListable {

    static func objects(from: [JSONObject]) throws -> [Self] {
        do {
            return try from.map(Self.init(json:))
        }
        catch let e {
            throw e
        }
    }

}
