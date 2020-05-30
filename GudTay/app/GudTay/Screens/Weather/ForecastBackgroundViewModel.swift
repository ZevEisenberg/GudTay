//
//  ForecastBackgroundViewModel.swift
//  GudTay
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

        var events = solarEvents

        // API does not return values before midnight for the day requested. We don't need
        // the exact time of the last solar event - the last one before midnight will suffice.
        // As a shortcut, just shift the second solar event back by by a day and call it good.
        // Also do this for the last value before the end of the day, even though it should
        // never manifest as a problem in production code, just for completeness.

        if let first = events.first, first.date.timeIntervalSinceReferenceDate > intervalInSeconds.lowerBound {
            guard let firstOppositeEvent = events.first(where: { $0.kind != first.kind }) else {
                preconditionFailure("We should have at least one event of the opposite kind")
            }

            guard let newDate = calendar.date(byAdding: .day, value: -1, to: firstOppositeEvent.date) else {
                preconditionFailure("Failed to subtract 1 day from \(firstOppositeEvent.date)")
            }
            let newEvent = SolarEvent(kind: firstOppositeEvent.kind, date: newDate)
            events.insert(newEvent, at: 0)
        }

        if let last = events.last, last.date.timeIntervalSinceReferenceDate < intervalInSeconds.upperBound {
            guard let lastOppositeEvent = events.reversed().first(where: { $0.kind != last.kind }) else {
                preconditionFailure("We should have at least one event of the opposite kind")
            }

            guard let newDate = calendar.date(byAdding: .day, value: 1, to: lastOppositeEvent.date) else {
                preconditionFailure("Failed to add 1 day to \(lastOppositeEvent.date)")
            }
            let newEvent = SolarEvent(kind: lastOppositeEvent.kind, date: newDate)
            events.append(newEvent)
        }

        let endpoints = zip(events, events.dropFirst()).map { (first: SolarEvent, second: SolarEvent) -> EventEndpoints in
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

        if let start = endpoints.first?.start, let end = endpoints.last?.end {
            assert(start <= 0.0)
            assert(end > 1.0)
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
