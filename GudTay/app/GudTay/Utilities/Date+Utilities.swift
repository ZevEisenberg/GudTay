//
//  Date+Extensions.swift
//  GudTay
//
//  Created by Zev Eisenberg on 10/9/16.
//  Copyright © 2016 Zev Eisenberg. All rights reserved.
//

import Foundation
import Swiftilities

extension Date {

    /// Returns the number of hours until the same wall clock time the following day,
    /// which might not be 24 hours depending on DST and other clock changes.
    ///
    /// - Parameter calendar: The calendar to use.
    /// - Returns: The number of hours until the same time the following day.
    func hoursUntilSameTimeNextDay(calendar: Calendar = Calendar.current) -> Int {

        var comps = calendar.dateComponents([
            .year,
            .month,
            .day,
            .hour,
            .minute,
            .second,
            .timeZone,
            ], from: self)
        comps.day? += 1

        guard let sameTimeTomorrow = calendar.date(from: comps) else {
            Log.error("couldn't get same time tomorrow for date \(self)")
            return 24
        }

        let interval = sameTimeTomorrow.timeIntervalSince(self)

        return Int(interval / (60.0 * 60.0))
    }

}
