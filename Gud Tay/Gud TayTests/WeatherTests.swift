//
//  GudTayTests.swift
//  GudTayTests
//
//  Created by Zev Eisenberg on 7/24/16.
//  Copyright © 2016 Zev Eisenberg. All rights reserved.
//

import XCTest
@testable import Gud_Tay

class GudTayTests: XCTestCase {

    func testForecast() {
        let exp = expectation(description: "forecastService")

        let viewModel = WeatherViewModel(serviceType: MockWeatherService.self)
        viewModel.refresh { result in
            switch result {
            case .success(let forecast):

                // coordinate
                do {
                    let coordinate = forecast.coordinate

                    XCTAssertEqualWithAccuracy(coordinate.lat, 42.3601, accuracy: 0.000001)
                    XCTAssertEqualWithAccuracy(coordinate.lon, -71.0589, accuracy: 0.000001)
                }

                // currently
                do {
                    let currently = forecast.currently

                    XCTAssertEqual(currently.meteorology.icon!, .clearDay)
                    XCTAssertEqualWithAccuracy(currently.temperature.current, 83.65, accuracy: 0.01)
                }

                // minutely
                do {
                    let minutely = forecast.minutely

                    let precipitation = minutely.precipitation
                    XCTAssertEqual(precipitation.summary, "Clear for the hour.")
                    XCTAssertEqual(precipitation.icon, .clearDay)
                    let events = precipitation.data
                    XCTAssertEqual(events.count, 61)
                    let precip0 = events[0]
                    XCTAssertEqualWithAccuracy(precip0.intensity, 0.017, accuracy: 0.001)
                    XCTAssertEqualWithAccuracy(precip0.probability, 0.3, accuracy: 0.001)
                    XCTAssertEqual(precip0.timestamp, Date(timeIntervalSince1970: 1470587040))
                }

                // hourly
                do {
                    let hourly = forecast.hourly

                    // precipitation
                    do {
                        let precipitation = hourly.precipitation
                        XCTAssertEqual(precipitation.summary, "Partly cloudy starting later this afternoon, continuing until this evening.")
                        XCTAssertEqual(precipitation.icon, .partlyCloudyDay)
                        let events = precipitation.data
                        XCTAssertEqual(events.count, 49)
                        let precip0 = events[0]
                        XCTAssertEqualWithAccuracy(precip0.intensity, 0.0, accuracy: 0.001)
                        XCTAssertEqualWithAccuracy(precip0.probability, 0.0, accuracy: 0.001)
                        XCTAssertEqual(precip0.timestamp, Date(timeIntervalSince1970: 1470585600))
                    }

                    // meteorology
                    do {
                        let meteorology = hourly.meteorology
                        XCTAssertEqual(meteorology.summary, "Partly cloudy starting later this afternoon, continuing until this evening.")
                        XCTAssertEqual(meteorology.icon, .partlyCloudyDay)
                        let events = meteorology.data
                        XCTAssertEqual(events.count, 49)
                        let meteorology0 = events[0]
                        XCTAssertEqualWithAccuracy(meteorology0.cloudCover, 0.02, accuracy: 0.001)
                        XCTAssertEqualWithAccuracy(meteorology0.dewPoint, 56.05, accuracy: 0.001)
                        XCTAssertEqualWithAccuracy(meteorology0.humidity, 0.39, accuracy: 0.001)
                        XCTAssertEqual(meteorology0.icon, .clearDay)
                        XCTAssertEqualWithAccuracy(meteorology0.ozone, 316.1, accuracy: 0.001)
                        XCTAssertEqualWithAccuracy(meteorology0.pressure, 1009.14, accuracy: 0.001)
                        XCTAssertEqual(meteorology0.summary, "Clear")
                        XCTAssertEqualWithAccuracy(meteorology0.visibility!, 10.0, accuracy: 0.001)
                        switch meteorology0.wind {
                        case .none:
                            XCTFail("it was .none")
                        case .some(let speed, let bearing):
                            XCTAssertEqualWithAccuracy(speed, 5.03, accuracy: 0.001)
                            XCTAssertEqualWithAccuracy(bearing, 291.0, accuracy: 0.001)
                        }
                    }

                    // temperature
                    do {
                        let temperature = hourly.temperature
                        XCTAssertEqual(temperature.summary, "Partly cloudy starting later this afternoon, continuing until this evening.")
                        XCTAssertEqual(temperature.icon, .partlyCloudyDay)
                        let events = temperature.data
                        XCTAssertEqual(events.count, 49)
                        let temperature0 = events[0]
                        XCTAssertEqualWithAccuracy(temperature0.current, 83.46, accuracy: 0.001)
                        XCTAssertEqualWithAccuracy(temperature0.apparent, 82.66, accuracy: 0.001)
                    }
                }

                // daily
                do {
                    let daily = forecast.daily

                    // meteorology
                    do {
                        let meteorology = daily.meteorology
                        XCTAssertEqual(meteorology.summary, "Light rain on Wednesday through Sunday, with temperatures peaking at 95°F on Thursday.")
                        XCTAssertEqual(meteorology.icon, .rain)
                        let events = meteorology.data
                        XCTAssertEqual(events.count, 8)
                        let meteorology0 = events[0]
                        XCTAssertEqualWithAccuracy(meteorology0.cloudCover, 0.16, accuracy: 0.001)
                        XCTAssertEqualWithAccuracy(meteorology0.dewPoint, 58.44, accuracy: 0.001)
                        XCTAssertEqualWithAccuracy(meteorology0.humidity, 0.55, accuracy: 0.001)
                        XCTAssertEqual(meteorology0.icon, .partlyCloudyDay)
                        XCTAssertEqualWithAccuracy(meteorology0.ozone, 313.3, accuracy: 0.001)
                        XCTAssertEqualWithAccuracy(meteorology0.pressure, 1008.7, accuracy: 0.001)
                        XCTAssertEqual(meteorology0.summary, "Partly cloudy starting in the afternoon, continuing until evening.")
                        XCTAssertEqualWithAccuracy(meteorology0.visibility!, 9.89, accuracy: 0.001)
                        switch meteorology0.wind {
                        case .none:
                            XCTFail()
                        case .some(let speed, let bearing):
                            XCTAssertEqualWithAccuracy(speed, 5.38, accuracy: 0.001)
                            XCTAssertEqualWithAccuracy(bearing, 291.0, accuracy: 0.001)
                        }
                    }

                    // almanac
                    do {
                        let daily = forecast.daily

                        let almanac = daily.almanac
                        XCTAssertEqual(almanac.summary, "Light rain on Wednesday through Sunday, with temperatures peaking at 95°F on Thursday.")
                        XCTAssertEqual(almanac.icon, .rain)
                        let events = almanac.data
                        XCTAssertEqual(events.count, 8)
                        let almanac0 = events[0]

                        let tempRange0 = almanac0.temperatureRange
                        XCTAssertEqualWithAccuracy(tempRange0.max, 84.73, accuracy: 0.001)
                        XCTAssertEqualWithAccuracy(tempRange0.min, 68.3, accuracy: 0.001)
                        XCTAssertEqual(tempRange0.minTime, Date(timeIntervalSince1970: 1470564000))
                        XCTAssertEqual(tempRange0.maxTime, Date(timeIntervalSince1970: 1470596400))

                        let apparentTempRange0 = almanac0.temperatureRange
                        XCTAssertEqualWithAccuracy(apparentTempRange0.max, 84.73, accuracy: 0.001)
                        XCTAssertEqualWithAccuracy(apparentTempRange0.min, 68.3, accuracy: 0.001)
                        XCTAssertEqual(apparentTempRange0.minTime, Date(timeIntervalSince1970: 1470564000))
                        XCTAssertEqual(apparentTempRange0.maxTime, Date(timeIntervalSince1970: 1470596400))

                        XCTAssertEqualWithAccuracy(almanac0.moonPhase, 0.16, accuracy: 0.001)

                        let precipitation0 = almanac0.precipitation
                        XCTAssertEqualWithAccuracy(precipitation0.intensity, 0.0002, accuracy: 0.00001)
                        XCTAssertEqualWithAccuracy(precipitation0.probability, 0.01, accuracy: 0.001)
                        XCTAssertEqual(precipitation0.timestamp, Date(timeIntervalSince1970: 1470542400))

                        switch almanac0.precipIntensityMax {
                        case .none:
                            XCTFail()
                        case .some(let value, let date):
                            XCTAssertEqualWithAccuracy(value, 0.001, accuracy: 0.0001)
                            XCTAssertEqual(date, Date(timeIntervalSince1970: 1470614400))
                        }

                        XCTAssertEqual(almanac0.precipType!, .rain)

                        XCTAssertEqual(almanac0.sunriseTime, Date(timeIntervalSince1970: 1470563088))
                        XCTAssertEqual(almanac0.sunsetTime, Date(timeIntervalSince1970: 1470614269))
                    }
                }
            case .failure(let error):
                XCTFail("got unexpected error: \(error)")
            }
            exp.fulfill()
        }

        waitForExpectations(timeout: 0.1, handler: nil)
    }

}
