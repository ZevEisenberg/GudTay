//
//  MBTATests.swift
//  GudTay
//
//  Created by ZevEisenberg on 11/3/16.
//  Copyright © 2017 ZevEisenberg. All rights reserved.
//

import OHHTTPStubs
@testable import Services
import XCTest

class MBTATests: XCTestCase {
    let client: APIClient = {
        let configuration = URLSessionConfiguration.default
        OHHTTPStubs.setEnabled(true, for: configuration)
        let client = APIClient(baseURL: TestClient.baseURL, configuration: configuration)
        return client
    }()
    override class func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
        OHHTTPStubs.removeAllStubs()
    }

    func testPredictions() {
        stub(condition: pathStartsWith("/predictions")) { _ in
            return OHHTTPStubsResponse(data: Payloads.MBTA.predictions, statusCode: 200, headers: nil)
        }

        let expectation = self.expectation(description: "Test Endpoint")
        client.request(TestEndpoint()) { _, error in
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        waitForExpectations(timeout: timeout, handler: nil)
    }

}
