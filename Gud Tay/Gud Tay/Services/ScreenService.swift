//
//  ScreenService.swift
//  Gud Tay
//
//  Created by Zev Eisenberg on 2/17/17.
//  Copyright © 2017 Zev Eisenberg. All rights reserved.
//

import UIKit
import Swiftilities

final class ScreenService {

    static func start() {
        let interval: TimeInterval = 60
        Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
            let date = Date()
            let brightness = ScreenService.brightness(for: date)
            LogService.add(message: "Setting brightness to \(brightness)")
            UIScreen.main.brightness = brightness
        }
    }

}

extension ScreenService {

    enum BrightnessStatus {
        case max
        case min
        case rising
        case falling
    }

    struct Time {

        let hours: Int
        let minutes: Int

        var allMinutes: Int {
            return hours * 60 + minutes
        }

        static var min: Time {
            return 0.00
        }

        static var max: Time {
            return 24.00
        }

    }

}

extension ScreenService {

    typealias BrightnessSegment = (range: Range<Time>, status: BrightnessStatus)
    private static let segments: [BrightnessSegment] = [
        (range: Time.min..<5.45, status :.min),
        (range: 5.45..<6.00, status: .rising),
        (range: 6.00..<19.45, status: .max),
        (range: 19.45..<20.00, status: .falling),
        (range: 20.00..<Time.max, status: .min),
        ]

    static func brightness(for date: Date) -> CGFloat {
        let calendar = Calendar(identifier: .gregorian)
        let comps = calendar.dateComponents([.hour, .minute], from: date)
        guard let hour = comps.hour, let minute = comps.minute else {
            return 1
        }

        let time = Time(hours: hour, minutes: minute)

        guard let (range, status) = ScreenService.segments.first(where: { $0.range.contains(time) }) else {
            preconditionFailure("Every time should fit into one of the segments")
        }

        switch status {
        case .max: return 1
        case .min: return 0
        case .falling, .rising:
            let timeMinutes = Double(time.allMinutes)
            let start = Double(range.lowerBound.allMinutes)
            let end = Double(range.upperBound.allMinutes)
            let transitionRange = start...end
            var normalized = timeMinutes.scaled(from: transitionRange, to: 0...1)
            if case .falling = status {
                normalized = 1 - normalized
            }
            return CGFloat(normalized)
        }
    }

}

extension ScreenService.Time: ExpressibleByFloatLiteral {

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

extension ScreenService.Time: CustomStringConvertible {

    var description: String {
        return String(format: "%d:%02d", hours, minutes)
    }

}

extension ScreenService.Time: Comparable {

    static func == (lhs: ScreenService.Time, rhs: ScreenService.Time) -> Bool {
        return lhs.hours == rhs.hours && lhs.minutes == rhs.minutes
    }

    static func < (lhs: ScreenService.Time, rhs: ScreenService.Time) -> Bool {
        if lhs.hours != rhs.hours {
            return lhs.hours < rhs.hours
        }
        else {
            return lhs.minutes < rhs.minutes
        }
    }

}
