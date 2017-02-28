//
//  JSON.swift
//  JSON
//
//  Created by Zev Eisenberg on 7/23/16.
//
//

import Foundation.NSDate

public typealias Object = [String: AnyObject]

public enum JSONError: Error {

    case generic
    case malformedOrMissingKey(key: String, parent: Any)
    case malformedValue(key: String, value: Any?, parent: Any)

}

public extension Dictionary {

    public func value<ReturnType>(key: Key) throws -> ReturnType {
        guard let anyValue = self[key] else {
            if let key = key as? String {
                throw JSONError.malformedOrMissingKey(key: key, parent: self)
            }
            else {
                throw JSONError.generic
            }
        }

        guard let value = anyValue as? ReturnType else {
            if let key = key as? String {
                throw JSONError.malformedValue(key: key, value: anyValue, parent: self)
            }
            else {
                throw JSONError.generic
            }
        }
        return value
    }

    public func optionalValue<ReturnType>(key: Key) -> ReturnType? {
        do {
            let value: ReturnType = try self.value(key: key)
            return value
        }
        catch {
            return nil
        }
    }

    public func date(key: Key) throws -> Date {

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

    public func optionalDate(key: Key) -> Date? {
        do {
            let date = try self.date(key: key)
            return date
        }
        catch {
            return nil
        }
    }

    public func timeInterval(key: Key) throws -> TimeInterval {
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

public protocol Representable {

    init(json: Object) throws

}

public protocol Listable: Representable {

    static func objects(from objects: [Object]) throws -> [Self]

}

public extension Listable {

    public static func objects(from objects: [Object]) throws -> [Self] {
        return try objects.map(Self.init(json:))
    }

}
