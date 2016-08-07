//
//  MBTATests.swift
//  GudTayTests
//
//  Created by Zev Eisenberg on 7/24/16.
//  Copyright © 2016 Zev Eisenberg. All rights reserved.
//

import XCTest
@testable import Gud_Tay

class MBTATests: XCTestCase {

    func testPredictionsByStop() {
        let exp = expectation(description: "mbtaService")

        let viewModel = MBTAViewModel(serviceType: MockMBTAService.self)
        viewModel.refresh { result in
            switch result {
            case .success(let trips):

                let subwayOrangeTrips = trips[0]
                XCTAssertEqual(subwayOrangeTrips, MBTAViewModel.UpcomingTrips.two(next: 243.0, later: 771.0))

                let busCT2Trips = trips[1]
                XCTAssertEqual(busCT2Trips, MBTAViewModel.UpcomingTrips.one(next: 826.0))

                let bus86Trips = trips[2]
                XCTAssertEqual(bus86Trips, MBTAViewModel.UpcomingTrips.one(next: 1000.0))

                let bus90Trips = trips[3]
                XCTAssertEqual(bus90Trips, MBTAViewModel.UpcomingTrips.one(next: 659.0))

                let bus91Trips = trips[4]
                XCTAssertEqual(bus91Trips, MBTAViewModel.UpcomingTrips.one(next: 1661.0))
            case .failure(let error):
                XCTFail("got unexpected error: \(error)")
            }
            exp.fulfill()
        }

        waitForExpectations(timeout: 0.1, handler: nil)

    }

}
