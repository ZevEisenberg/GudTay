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
                print(forecast)
            case .failure(let error):
                XCTFail("got unexpected error: \(error)")
            }
            exp.fulfill()
        }

        waitForExpectations(timeout: 0.1, handler: nil)

    }

}
