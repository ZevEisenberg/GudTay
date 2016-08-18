//
//  LogService.swift
//  Gud Tay
//
//  Created by Zev Eisenberg on 8/17/16.
//  Copyright © 2016 Zev Eisenberg. All rights reserved.
//

enum LogService {

    // Private Properties

    fileprivate(set) static var messages = [String]()

}

extension LogService {

    static func add(message: String) {
        LogService.messages.append("\(Date()) - \(message)")
        if LogService.messages.count > 200 {
            LogService.messages.removeFirst()
        }
    }

    static func clear() {
        LogService.messages = ["Starting up at \(Date())"]
    }

}
