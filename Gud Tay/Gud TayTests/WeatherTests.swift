//
//  GudTayTests.swift
//  GudTayTests
//
//  Created by Zev Eisenberg on 7/24/16.
//  Copyright © 2016 Zev Eisenberg. All rights reserved.
//

import XCTest

class GudTayTests: XCTestCase {

    let referenceDate = Date(timeIntervalSince1970: 1470587079.0)

    func testForecastFields() {
        let exp = expectation(description: "testForecastFields")

        let viewModel = WeatherViewModel(serviceType: MockWeatherService<WithRain>.self)
        viewModel.refresh(referenceDate: referenceDate, calendar: Calendar(identifier: .gregorian)) { result in
            switch result {
            case let .success(fields, _):

                let tempField = fields[0]

                guard case WeatherViewModel.WeatherField.temperatures(let current, let high, let low) = tempField else {
                    XCTFail("unexpected thingy: \(tempField)")
                    break
                }

                XCTAssertEqualWithAccuracy(current, 83.65, accuracy: 0.001)
                XCTAssertEqualWithAccuracy(high, 84.73, accuracy: 0.001)
                XCTAssertEqualWithAccuracy(low, 68.3, accuracy: 0.001)

                let iconField = fields[1]

                guard case WeatherViewModel.WeatherField.currentIcon(let icon) = iconField else {
                    XCTFail("unexpected thingy: \(iconField)")
                    break
                }

                XCTAssertEqual(icon, .clearDay)

                let umbrellaField = fields[2]

                guard case WeatherViewModel.WeatherField.needUmbrella = umbrellaField else {
                    XCTFail("unexpectedly did not need an umbrella")
                    return
                }

                let hourlyFields = Array(fields.suffix(from: 3))

                XCTAssertEqual(hourlyFields.count, 24)

                for field in hourlyFields {
                    if case WeatherViewModel.WeatherField.hour(time: _, icon: _, temp: _, precipProbability: _) = field {
                    }
                    else {
                        XCTFail()
                    }
                }

                let hour0 = hourlyFields[0]

                guard case WeatherViewModel.WeatherField.hour(let time0, let icon0, let temp0, let precipProbability0) = hour0 else {
                    XCTFail()
                    return
                }

                XCTAssertEqual(time0, Date(timeIntervalSince1970: 1470585600))
                XCTAssertEqual(icon0, .clearDay)
                XCTAssertEqualWithAccuracy(temp0, 83.46, accuracy: 0.001)
                XCTAssertEqualWithAccuracy(precipProbability0!, 0.0, accuracy: 0.001)

                let hour2 = hourlyFields[2]

                guard case WeatherViewModel.WeatherField.hour(let time2, let icon2, let temp2, let precipProbability2) = hour2 else {
                    XCTFail()
                    return
                }

                XCTAssertEqual(time2, Date(timeIntervalSince1970: 1470592800))
                XCTAssertEqual(icon2, .rain)
                XCTAssertEqualWithAccuracy(temp2, -12.34, accuracy: 0.001)
                XCTAssertEqualWithAccuracy(precipProbability2!, 0.9, accuracy: 0.001)

            case .failure(let error):
                XCTFail("got unexpected error: \(error)")
            }
            exp.fulfill()
        }

        waitForExpectations(timeout: 0.1, handler: nil)
    }

    func testForecastBackgroundViewModel() {
        let exp = expectation(description: "testForecastBackgroundViewModel")

        let viewModel = WeatherViewModel(serviceType: MockWeatherService<FlipFlopping>.self)
        viewModel.refresh(referenceDate: referenceDate, calendar: Calendar(identifier: .gregorian)) { result in
            switch result {
            case let .success(_, backgroundVM):
                defer {
                    exp.fulfill()
                }

                guard let backgroundVM = backgroundVM else {
                    XCTFail("Got unexpectedly nil background view model")
                    return
                }

                let testInterval = DateInterval(
                    start: Date(timeIntervalSinceReferenceDate: 492278400.0),
                    end: Date(timeIntervalSinceReferenceDate: 492361200.0)
                )
                XCTAssertEqual(backgroundVM.interval, testInterval)

                let ratios = backgroundVM.eventEndpoints(calendar: Calendar(identifier: .gregorian))
                XCTAssertEqual(ratios.count, 4)

                let first = ratios[0]
                XCTAssertEqual(first.kind, .day)
                XCTAssertEqualWithAccuracy(first.start, -0.271884057971015, accuracy: 0.001)
                XCTAssertEqualWithAccuracy(first.end, 0.346243961352657, accuracy: 0.001)

                let second = ratios[1]
                XCTAssertEqual(second.kind, .night)
                XCTAssertEqualWithAccuracy(second.start, 0.346243961352657, accuracy: 0.001)
                XCTAssertEqualWithAccuracy(second.end, 0.772355072463768, accuracy: 0.001)

                let third = ratios[2]
                XCTAssertEqual(third.kind, .day)
                XCTAssertEqualWithAccuracy(third.start, 0.772355072463768, accuracy: 0.001)
                XCTAssertEqualWithAccuracy(third.end, 1.38878019323671, accuracy: 0.001)

                let fourth = ratios[3]
                XCTAssertEqual(fourth.kind, .night)
                XCTAssertEqualWithAccuracy(fourth.start, 1.38878019323671, accuracy: 0.001)
                XCTAssertEqualWithAccuracy(fourth.end, 1.81660628019324, accuracy: 0.001)

            case .failure(let error):
                XCTFail("got unexpected error: \(error)")
            }
        }

        waitForExpectations(timeout: 0.1, handler: nil)
    }

    func testJustAfterSunset() {
        let afterSunsetReferenceDate = Date(timeIntervalSinceReferenceDate: 506125318)

        let exp = expectation(description: "testJustAfterSunset")

        let viewModel = WeatherViewModel(serviceType: MockWeatherService<JustAfterSunset>.self)
        viewModel.refresh(referenceDate: afterSunsetReferenceDate, calendar: Calendar(identifier: .gregorian)) { result in
            switch result {
            case let .success(_, backgroundVM):
                defer {
                    exp.fulfill()
                }

                guard let backgroundVM = backgroundVM else {
                    XCTFail("Got unexpectedly nil background view model")
                    return
                }

                let testInterval = DateInterval(
                    start: Date(timeIntervalSinceReferenceDate: 506124000.0),
                    end: Date(timeIntervalSinceReferenceDate: 506206800.0)
                )
                XCTAssertEqual(backgroundVM.interval, testInterval)

                let ratios = backgroundVM.eventEndpoints(calendar: Calendar(identifier: .gregorian))
                XCTAssertEqual(ratios.count, 4)
            case .failure(let error):
                XCTFail("got unexpected error: \(error)")
            }
        }

        waitForExpectations(timeout: 0.1, handler: nil)
    }

    func testJustAfterMidnight() {
        let afterMidnightReferenceDate = Date(timeIntervalSinceReferenceDate: 509692380)

        let exp = expectation(description: "testJustAfterMidnight")

        let viewModel = WeatherViewModel(serviceType: MockWeatherService<JustAfterMidnight>.self)
        viewModel.refresh(referenceDate: afterMidnightReferenceDate, calendar: Calendar(identifier: .gregorian)) { result in
            switch result {
            case let .success(_, backgroundVM):
                defer {
                    exp.fulfill()
                }

                guard let backgroundVM = backgroundVM else {
                    XCTFail("Got unexpectedly nil background view model")
                    return
                }

                let testInterval = DateInterval(
                    start: Date(timeIntervalSinceReferenceDate: 509659200.0),
                    end: Date(timeIntervalSinceReferenceDate: 509742000.0)
                )
                XCTAssertEqual(backgroundVM.interval, testInterval)

                let ratios = backgroundVM.eventEndpoints(calendar: Calendar(identifier: .gregorian))
                XCTAssertEqual(ratios.count, 3)
            case .failure(let error):
                XCTFail("got unexpected error: \(error)")
            }
        }

        waitForExpectations(timeout: 0.1, handler: nil)
    }

    func testDryDateInterval() {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(abbreviation: "EDT")!
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        formatter.calendar = calendar
        let today = formatter.date(from: "2016-08-22 08:24:57 -0400")!

        let interval = WeatherViewModel.desiredDryInterval(for: today, calendar: calendar)

        let controlStartDate = formatter.date(from: "2016-08-22 07:00:00 -0400")!
        let controlEndDate = formatter.date(from: "2016-08-22 23:00:00 -0400")!

        let controlInterval = DateInterval(start: controlStartDate, end: controlEndDate)

        XCTAssertEqual(interval, controlInterval)
    }

}
