//
//  ClockTimeTests.swift
//  Gud Tay
//
//  Created by Zev Eisenberg on 3/12/17.
//  Copyright © 2017 Zev Eisenberg. All rights reserved.
//

import XCTest

class ClockTimeTests: XCTestCase {

    func testTime() {
        for hour in 0...23 {
            for minute in 0...59 {
                let double = Double(String(format: "%d.%02d", hour, minute))!
                let time = ClockTime(floatLiteral: double)
                let control = String(format: "%d:%02d", hour, minute)
                XCTAssertEqual(time.description, control)
            }
        }
    }

    func testTwelveHourTime() {
        let beforeNoon: ClockTime = 8.53
        XCTAssertEqual(beforeNoon.asTwelveHour.hours, 8)
        XCTAssertEqual(beforeNoon.asTwelveHour.minutes, 53)

        XCTAssertEqual(beforeNoon.asTwelveHour, beforeNoon)

        let noon: ClockTime = 12.00
        XCTAssertEqual(noon.asTwelveHour.hours, 0)
        XCTAssertEqual(noon.asTwelveHour.minutes, 00)

        let justAfterNoon: ClockTime = 12.01
        XCTAssertEqual(justAfterNoon.asTwelveHour.hours, 0)
        XCTAssertEqual(justAfterNoon.asTwelveHour.minutes, 01)

        let wellAfterNoon: ClockTime = 13.01
        XCTAssertEqual(wellAfterNoon.asTwelveHour.hours, 1)
        XCTAssertEqual(wellAfterNoon.asTwelveHour.minutes, 01)

        let nearlyMidnight: ClockTime = 23.59
        XCTAssertEqual(nearlyMidnight.asTwelveHour.hours, 11)
        XCTAssertEqual(nearlyMidnight.asTwelveHour.minutes, 59)
    }

    func testHandRotations() {

        let testsLine: UInt = #line; let tests: [(time: ClockTime, rotations: (hourRotation: CGFloat, minuteRotation: CGFloat))] = [
            (12.00, (hourRotation: 0.0, minuteRotation: 0.0)),
            (12.30, (hourRotation: (2 * .pi / 24.0), minuteRotation: .pi)),
            (3.00, (hourRotation: .pi / 2.0, minuteRotation: 0.0)),
        ]

        for (index, test) in tests.enumerated() {
            let testLine = testsLine + UInt(index) + 1
            let rotations = test.time.handRotations
            XCTAssertEqual(rotations.hour, test.rotations.hourRotation, accuracy: 0.0001, line: testLine)
            XCTAssertEqual(rotations.minute, test.rotations.minuteRotation, accuracy: 0.0001, line: testLine)
        }
    }

}
