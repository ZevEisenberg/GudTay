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

    func optionalValue<ReturnType>(key: Key) -> ReturnType? {
        do {
            let value: ReturnType = try self.value(key: key)
            return value
        }
        catch {
            return nil
        }
    }

    func date(key: Key) throws -> Date {

        var secondsSinceEpoch: TimeInterval

        let value = self[key]

        if let dateString = value as? String {
            guard let seconds = TimeInterval(dateString) else {
                if let key = key as? String {
                    throw JSONError.malformedValue(key: key, value: dateString, parent: self)
                }
                else {
                    throw JSONError.generic
                }
            }
            secondsSinceEpoch = seconds
        }
        else if let dateNumber = value as? TimeInterval {
            secondsSinceEpoch = dateNumber
        }
        else {
            if let key = key as? String {
                throw JSONError.malformedValue(key: key, value: value, parent: self)
            }
            else {
                throw JSONError.generic
            }
        }

        return Date(timeIntervalSince1970: secondsSinceEpoch)
    }

    func optionalDate(key: Key) -> Date? {
        do {
            let date = try self.date(key: key)
            return date
        }
        catch {
            return nil
        }
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

    static func objects(from objects: [JSONObject]) throws -> [Self]

}

extension JSONListable {

    static func objects(from objects: [JSONObject]) throws -> [Self] {
        return try objects.map(Self.init(json:))
    }

}
