//
//  LogService.swift
//  Service
//
//  Created by Zev Eisenberg on 8/17/16.
//  Copyright © 2016 Zev Eisenberg. All rights reserved.
//

import Foundation.NSDate

private let snapshotsToKeep = 10

public enum LogService {

    // Public Properites

    public static var messages: [String] {
        queue.sync { _messages }
    }

    public static var apiSnapshots: [String: [Data]] {
        queue.sync { _apiSnapshots }
    }

    // Private Properties

    private static var _messages: [String] = []
    private static var _apiSnapshots: [String: [Data]] = [:]

    private static let queue = DispatchQueue(label: "LogService", qos: .background, attributes: [], autoreleaseFrequency: .workItem, target: nil)

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = .autoupdatingCurrent
        formatter.calendar = .autoupdatingCurrent
        formatter.timeStyle = .long
        formatter.dateStyle = .medium
        return formatter
    }()

}

public extension LogService {

    static func add(message: String, date: Date = Date()) {
        queue.async {
            LogService._messages.append("\(LogService.dateFormatter.string(from: date)) - \(message)")
            if LogService._messages.count > 200 {
                LogService._messages.removeFirst()
            }
        }
    }

    static func add(apiSnapshot: Data, forSubsystem subsystemKey: String) {
        queue.async {
            var array = _apiSnapshots[subsystemKey, default: []]
                .suffix(snapshotsToKeep)
            array.append(apiSnapshot)
            _apiSnapshots[subsystemKey] = Array(array)
        }
    }

    static func clear() {
        queue.async {
            LogService._messages = ["Starting up at \(LogService.dateFormatter.string(from: Date()))"]
        }
    }

}
