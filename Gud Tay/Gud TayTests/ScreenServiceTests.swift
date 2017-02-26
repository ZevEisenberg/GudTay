//
//  ScreenServiceTests.swift
//  Gud Tay
//
//  Created by Zev Eisenberg on 2/17/17.
//  Copyright © 2017 Zev Eisenberg. All rights reserved.
//

import XCTest
@testable import Gud_Tay

typealias Time = ScreenService.Time

class ScreenServiceTests: XCTestCase {

    func testTime() {

        for hour in 0...23 {
            for minute in 0...59 {
                let double = Double(String(format: "%d.%02d", hour, minute))!
                let time = Time(floatLiteral: double)
                let control = String(format: "%d:%02d", hour, minute)
                XCTAssertEqual(time.description, control)
            }
        }

    }

    func testBrightnessFunction() {
        let valuesLine = #line; let values: [(ScreenService.Time, CGFloat)] = [
            (0.00, 0),
            (0.01, 0),
            (3.00, 0),
            (5.45, 0),
            (5.52, 0.46666),
            (6.00, 1),
            (6.15, 1),
            (9.41, 1),
            (12.00, 1),
            (12.00, 1),
            (21.45, 1),
            (21.58, 0.13333),
            (22.0, 0),
            (23.59, 0),
        ]

        for (index, (date, brightness)) in values.enumerated() {
            let line = UInt(valuesLine + index + 1)
            let testBrightness = ScreenService.brightness(for: testingDate(from: date))
            XCTAssertEqualWithAccuracy(testBrightness, brightness, accuracy: 0.01, line: line)
        }

    }

}

private extension ScreenServiceTests {

    func testingDate(from time: ScreenService.Time) -> Date {
        let calendar = Calendar(identifier: .gregorian)
        let timeZone = TimeZone(identifier: "EDT")

        let comps = DateComponents(
            calendar: calendar,
            timeZone: timeZone,
            year: 2017,
            month: 2,
            day: 17,
            hour: time.hours,
            minute: time.minutes)
        return comps.date!
    }

}
