//
//  LogService.swift
//  Service
//
//  Created by Zev Eisenberg on 8/17/16.
//  Copyright © 2016 Zev Eisenberg. All rights reserved.
//

import Foundation.NSDate

public enum LogService {

    // Private Properties

    private(set) public static var messages = [String]()

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = .autoupdatingCurrent
        formatter.calendar = .autoupdatingCurrent
        formatter.timeStyle = .long
        formatter.dateStyle = .medium
        return formatter
    }()

}

extension LogService {

    public static func add(message: String, date: Date = Date()) {
        LogService.messages.append("\(LogService.dateFormatter.string(from: date)) - \(message)")
        if LogService.messages.count > 200 {
            LogService.messages.removeFirst()
        }
    }

    public static func clear() {
        LogService.messages = ["Starting up at \(LogService.dateFormatter.string(from: Date()))"]
    }

}
