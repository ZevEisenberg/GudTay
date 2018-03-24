//
//  MBTATests.swift
//  GudTayTests
//
//  Created by Zev Eisenberg on 7/24/16.
//  Copyright © 2016 Zev Eisenberg. All rights reserved.
//

import XCTest

class MBTATests: XCTestCase {

    func testPredictionsByStop() {
        let exp = expectation(description: "mbtaService")

        let viewModel = MBTAViewModel(serviceType: MockMBTAService.self)
        viewModel.refresh { result in
            switch result {
            case .success(let trips):

                let bus32Trips = trips[0]
                XCTAssertEqual(bus32Trips, MBTAViewModel.UpcomingTrips.two(next: 1173, later: 1893))
            case .failure(let error):
                XCTFail("got unexpected error: \(error)")
            }
            exp.fulfill()
        }

        waitForExpectations(timeout: 0.1, handler: nil)

    }

    func testDecodingVehicle() {

        let testVehicle = [
            "vehicle_id": "5447D16F",
            "vehicle_lat": "42.43223",
            "vehicle_lon": "-71.07213",
            "vehicle_bearing": "200",
            "vehicle_timestamp": "1471093360",
            ]

        do {
            let encoded = try JSONSerialization.data(withJSONObject: testVehicle, options: [])

            let vehicle = try JSONDecoder().decode(Vehicle.self, from: encoded)

            XCTAssertEqual(vehicle.identifier, "5447D16F")
            XCTAssertEqual(vehicle.location.bearing, 200)
            XCTAssertEqual(vehicle.location.lat, 42.43223, accuracy: 0.001)
            XCTAssertEqual(vehicle.location.lon, -71.07213, accuracy: 0.001)
        }
        catch {
            XCTFail("Failed with error: \(error)")
        }
    }

}
