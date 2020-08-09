//
//  OpenWeatherTests.swift
//  GudTayTests
//
//  Created by Zev Eisenberg on 5/28/20.
//

import OHHTTPStubs
import OHHTTPStubsSwift
@testable import Services
import XCTest

final class OpenWeatherTests: XCTestCase {

    let service: OpenWeatherService = {
        let configuration = URLSessionConfiguration.default
        HTTPStubs.setEnabled(true, for: configuration)
        let service = OpenWeatherService(configuration: configuration)
        return service
    }()

    override func tearDown() {
        super.tearDown()
        HTTPStubs.removeAllStubs()
    }

    func testForecast() {
        stub(condition: pathStartsWith("/data/2.5/onecall")) { _ in
            HTTPStubsResponse(data: Payloads.OpenWeather.forecast, statusCode: 200, headers: nil)
        }

        let expectation = self.expectation(description: "Test Endpoint")
        service.forecast { result in
            XCTAssert(result.isSuccess)
            if !result.isSuccess {
                XCTFail("Unexpected error: \(result.error!)")
            }
            XCTAssertEqual(result.success?.hourly.count, 48)
            expectation.fulfill()
        }
        waitForExpectations(timeout: timeout, handler: nil)
    }

}
