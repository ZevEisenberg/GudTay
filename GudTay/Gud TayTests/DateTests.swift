//
//  DateTests.swift
//  Gud Tay
//
//  Created by Zev Eisenberg on 10/9/16.
//  Copyright © 2016 Zev Eisenberg. All rights reserved.
//

import Foundation
import XCTest

class DateTests: XCTestCase {

    func testHoursUntilSameTimeNextDay() {
        let calendar = Calendar(identifier: .gregorian)
        let timeZone = TimeZone(identifier: "EDT")

        let dstStart4AM: Date = {
            let comps = DateComponents(
                timeZone: timeZone,
                year: 2015,
                month: 3,
                day: 8,
                hour: 4,
                minute: 0,
                second: 0)
            let date = calendar.date(from: comps)
            return date!
        }()

        let dstStart1AM: Date = {
            let comps = DateComponents(
                timeZone: timeZone,
                year: 2015,
                month: 3,
                day: 8,
                hour: 1,
                minute: 0,
                second: 0)
            let date = calendar.date(from: comps)
            return date!
        }()

        let dstEnd4AM: Date = {
            let comps = DateComponents(
                timeZone: timeZone,
                year: 2015,
                month: 11,
                day: 1,
                hour: 4,
                minute: 0,
                second: 0)
            let date = calendar.date(from: comps)
            return date!
        }()

        let dstEnd1AM: Date = {
            let comps = DateComponents(
                timeZone: timeZone,
                year: 2015,
                month: 11,
                day: 1,
                hour: 1,
                minute: 0,
                second: 0)
            let date = calendar.date(from: comps)
            return date!
        }()

        XCTAssertEqual(dstStart1AM.hoursUntilSameTimeNextDay(calendar: calendar), 23)
        XCTAssertEqual(dstStart4AM.hoursUntilSameTimeNextDay(calendar: calendar), 24)
        XCTAssertEqual(dstEnd1AM.hoursUntilSameTimeNextDay(calendar: calendar), 25)
        XCTAssertEqual(dstEnd4AM.hoursUntilSameTimeNextDay(calendar: calendar), 24)
    }

}
