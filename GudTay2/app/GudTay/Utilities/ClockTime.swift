//
//  Time.swift
//  GudTay
//
//  Created by Zev Eisenberg on 3/12/17.
//  Copyright © 2017 Zev Eisenberg. All rights reserved.
//

import Foundation

struct ClockTime: Equatable {

    let hours: Int
    let minutes: Int

    var allMinutes: Int {
        return hours * 60 + minutes
    }

    static var min: ClockTime {
        return 0.00
    }

    static var max: ClockTime {
        return 24.00
    }

}

extension ClockTime: ExpressibleByFloatLiteral {

    init(floatLiteral value: Double) {
        let hours = Int(floor(value))
        let rawMinutes = value.truncatingRemainder(dividingBy: 1.0)
        let minutes = Int(round(rawMinutes * 100))

        if hours < 0 || minutes < 0 || minutes > 59 {
            preconditionFailure("Invalid time \(hours):\(minutes)")
        }

        self.init(hours: hours, minutes: minutes)
    }

}

extension ClockTime: CustomStringConvertible {

    var description: String {
        return String(format: "%d:%02d", hours, minutes)
    }

}

extension ClockTime: Comparable {

    static func < (lhs: ClockTime, rhs: ClockTime) -> Bool {
        if lhs.hours != rhs.hours {
            return lhs.hours < rhs.hours
        }
        else {
            return lhs.minutes < rhs.minutes
        }
    }

}

extension Date {

    func clockTime(calendar: Calendar = .autoupdatingCurrent) -> ClockTime {
        let comps = calendar.dateComponents([.hour, .minute], from: self)
        guard let hour = comps.hour, let minute = comps.minute else {
            preconditionFailure("What kind of date doesn't have hours and minutes? This kind: \(self)")
        }

        return ClockTime(hours: hour, minutes: minute)
    }

}
