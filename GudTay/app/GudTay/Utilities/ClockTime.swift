//
//  Time.swift
//  GudTay
//
//  Created by Zev Eisenberg on 3/12/17.
//  Copyright © 2017 Zev Eisenberg. All rights reserved.
//

import Foundation

private let secondsPerMinute = 60
private let minutesPerHour = 60

struct ClockTime: Equatable {

    let hours: Int
    let minutes: Int
    let seconds: Int

    var minutesInSeconds: Int {
        return (minutes * secondsPerMinute) + seconds
    }

    var allSeconds: Int {
        return (hours * minutesPerHour * secondsPerMinute)
        + (minutes * secondsPerMinute)
        + seconds
    }

    static var min: ClockTime {
        return ClockTime(hours: 00, minutes: 00, seconds: 00)
    }

    static var max: ClockTime {
        return ClockTime(hours: 24, minutes: 00, seconds: 00)
    }

}

extension ClockTime: CustomStringConvertible {

    var description: String {
        return String(format: "%d:%02d:%02d", hours, minutes, seconds)
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
        let comps = calendar.dateComponents([.hour, .minute, .second], from: self)
        guard let hour = comps.hour, let minute = comps.minute, let second = comps.second else {
            preconditionFailure("What kind of date doesn't have hours, minutes, and seconds? This kind: \(self)")
        }

        return ClockTime(hours: hour, minutes: minute, seconds: second)
    }

}
