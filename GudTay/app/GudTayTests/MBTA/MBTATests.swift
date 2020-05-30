//
//  MBTATests.swift
//  GudTay
//
//  Created by ZevEisenberg on 11/3/16.
//  Copyright © 2017 ZevEisenberg. All rights reserved.
//

import OHHTTPStubs
import OHHTTPStubsSwift
@testable import Services
import XCTest

class MBTATests: XCTestCase {
    let service: MBTAService = {
        let configuration = URLSessionConfiguration.default
        HTTPStubs.setEnabled(true, for: configuration)
        let service = MBTAService(configuration: configuration)
        return service
    }()

    override func tearDown() {
        super.tearDown()
        HTTPStubs.removeAllStubs()
    }

    func testPredictions() {
        stub(condition: pathStartsWith("/predictions")) { _ in
            HTTPStubsResponse(data: Payloads.MBTA.predictions, statusCode: 200, headers: nil)
        }

        let expectation = self.expectation(description: "Test Endpoint")
        _ = service.getPredictions(forStop: "6480") { result in
            XCTAssert(result.isSuccess)
            if !result.isSuccess {
                XCTFail("Unexpected error: \(result.error!)")
            }
            XCTAssertEqual(result.success?.count, 4)
            expectation.fulfill()
        }
        waitForExpectations(timeout: timeout, handler: nil)
    }

}
