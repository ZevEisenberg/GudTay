//
//  ForecastBackgroundViewModel.swift
//  Gud Tay
//
//  Created by Zev Eisenberg on 10/10/16.
//  Copyright © 2016 Zev Eisenberg. All rights reserved.
//

import CoreGraphics
import Foundation
import Swiftilities

struct SolarEvent {

    enum Kind {

        case sunrise
        case sunset

    }

    let kind: Kind
    let date: Date

    func clone(offsetByDays days: Int, calendar: Calendar) -> SolarEvent {
        guard let newDate = calendar.date(byAdding: .day, value: days, to: date) else {
            preconditionFailure("Should always be able to add or subtract some days from an event")
        }
        let newEvent = SolarEvent(
            kind: kind,
            date: newDate)
        return newEvent
    }

}

enum SolarInterval {

    case day
    case night

}

struct ForecastBackgroundViewModel {

    let interval: DateInterval
    let solarEvents: [SolarEvent]

    typealias EventEndpoints = (kind: SolarInterval, start: CGFloat, end: CGFloat)

    func eventEndpoints(calendar: Calendar) -> [EventEndpoints] {
        precondition(solarEvents.count >= 2, "There should be at least two solar events per day")

        let intervalInSeconds = interval.start.timeIntervalSinceReferenceDate...interval.end.timeIntervalSinceReferenceDate
        let normalInterval = 0.0...1.0

        let endpoints = zip(solarEvents, solarEvents.dropFirst()).map { first, second -> EventEndpoints in
            assert(second.date > first.date, "events should be ordered ascending by date")
            assert(first.kind != second.kind, "events should alternate between sunrise and sunset")

            let startRatio = CGFloat(first.date.timeIntervalSinceReferenceDate.scaled(from: intervalInSeconds, to: normalInterval))
            let endRatio = CGFloat(second.date.timeIntervalSinceReferenceDate.scaled(from: intervalInSeconds, to: normalInterval))

            let kind: SolarInterval
            switch first.kind {
            case .sunrise: kind = .day
            case .sunset: kind = .night
            }
            return (kind: kind, start: startRatio, end: endRatio)
        }
        return endpoints
    }

    /// The ratio of the duration of the transition to the total duration
    /// represented by this view model.
    var transitionDurationRatio: CGFloat {
        let transitionMinutes = 45.0 // thanks, Ash Furrow
        let transitionSeconds: TimeInterval = transitionMinutes * 60.0
        let ratio = transitionSeconds / interval.duration
        return CGFloat(ratio)
    }

}
