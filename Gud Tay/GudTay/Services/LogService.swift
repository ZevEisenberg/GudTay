//
//  LogService.swift
//  Gud Tay
//
//  Created by Zev Eisenberg on 8/17/16.
//  Copyright © 2016 Zev Eisenberg. All rights reserved.
//

import Foundation.NSDate

enum LogService {

    // Private Properties

    fileprivate(set) static var messages = [String]()

    fileprivate static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = .autoupdatingCurrent
        formatter.calendar = .autoupdatingCurrent
        formatter.timeStyle = .long
        formatter.dateStyle = .medium
        return formatter
    }()

}

extension LogService {

    static func add(message: String, date: Date = Date()) {
        LogService.messages.append("\(LogService.dateFormatter.string(from: date)) - \(message)")
        if LogService.messages.count > 200 {
            LogService.messages.removeFirst()
        }
    }

    static func clear() {
        LogService.messages = ["Starting up at \(LogService.dateFormatter.string(from: Date()))"]
    }

}
