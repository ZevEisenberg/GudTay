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
            case .success(let fields):

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
                XCTAssertEqual(icon0, .partlyCloudyDay)
                XCTAssertEqualWithAccuracy(temp0, 83.46, accuracy: 0.001)
                XCTAssertEqualWithAccuracy(precipProbability0!, 0.0, accuracy: 0.001)

            case .failure(let error):
                XCTFail("got unexpected error: \(error)")
            }
            exp.fulfill()
        }

        waitForExpectations(timeout: 0.1, handler: nil)
    }

}
