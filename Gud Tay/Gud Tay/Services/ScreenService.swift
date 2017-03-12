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
            if brightness != UIScreen.main.brightness {
                LogService.add(message: "Setting brightness to \(brightness)", date: date)
            }
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

}

extension ScreenService {

    typealias BrightnessSegment = (range: Range<ClockTime>, status: BrightnessStatus)
    private static let segments: [BrightnessSegment] = [
        (range: ClockTime.min..<5.45, status :.min),
        (range: 5.45..<6.00, status: .rising),
        (range: 6.00..<21.45, status: .max),
        (range: 21.45..<22.00, status: .falling),
        (range: 22.00..<ClockTime.max, status: .min),
        ]

    static func brightness(for date: Date) -> CGFloat {
        let time = date.clockTime()

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
