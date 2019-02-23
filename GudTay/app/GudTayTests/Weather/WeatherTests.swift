//
//  WeatherTests.swift
//  GudTayTests
//
//  Created by Zev Eisenberg on 2/20/19.
//

@testable import GudTay
import Then
import XCTest

class WeatherTests: XCTestCase {

    let calendar = Calendar(identifier: .gregorian).with {
        $0.timeZone = TimeZone(secondsFromGMT: 0)!
    }

    func testBeforeInterval() {
        let date = makeDate(hour: 5, minute: 10)
        let interval = WeatherViewModel.interestingHourlyInterval(for: date, calendar: calendar)

        XCTAssertNil(interval)
    }

    func testInsideInterval() {
        let date = makeDate(hour: 8, minute: 3)
        let interval = WeatherViewModel.interestingHourlyInterval(for: date, calendar: calendar)
        XCTAssertEqual(interval?.start, makeDate(hour: 8, minute: 3))
        XCTAssertEqual(interval?.end, makeDate(hour: 23, minute: 0))
    }

}

extension Calendar: Then {}

private extension WeatherTests {

    func makeDate(
        year: Int = 2019,
        month: Int = 2,
        day: Int = 22,
        hour: Int = 6,
        minute: Int = 22,
        second: Int = 0) -> Date {
        return DateComponents(
            calendar: calendar,
            timeZone: calendar.timeZone,
            year: year,
            month: month,
            day: day,
            hour: hour,
            minute: minute,
            second: second
            ).date!
    }

}
