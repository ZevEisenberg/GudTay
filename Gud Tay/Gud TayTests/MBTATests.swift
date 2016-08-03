//
//  GudTayTests.swift
//  GudTayTests
//
//  Created by Zev Eisenberg on 7/24/16.
//  Copyright © 2016 Zev Eisenberg. All rights reserved.
//

import XCTest
@testable import Gud_Tay

class DummyClass: NSObject { }

enum MockMBTAService: MBTAServiceType {

    static func predictionsByStop(stopId: String, completion: (APIClient.Result) -> ()) {
        XCTAssertTrue(stopId == "place-sull")
        let filename = "Sample MBTA API Response"
        let ext = "json"
        guard let url = Bundle(for: DummyClass.self).url(forResource: filename, withExtension: ext) else {
            XCTFail("Could not find URL of \(filename).\(ext)")
            return
        }

        var jsonData: Data! = nil
        do {
            jsonData = try Data(contentsOf: url)
        }
        catch let e {
            XCTFail("Error getting contents of \(filename)\(ext): \(e)")
        }

        var deserialized: AnyObject! = nil
        do {
            deserialized = try JSONSerialization.jsonObject(with: jsonData, options: [])
        }
        catch let e {
            XCTFail("Error deserializing JSON data: \(e)")
        }

        guard let jsonObject = deserialized as? JSONObject else {
            XCTFail("Could not convert deserialized JSON to a JSONObject: \(deserialized)")
            return
        }

        completion(.success(jsonObject))
    }

}

class GudTayTests: XCTestCase {

    func testPredictionsByStop() {
        let exp = expectation(description: "mbtaService")

        let viewModel = MBTAViewModel(serviceType: MockMBTAService.self)
        viewModel.refresh { result in
            switch result {
            case .success(let tripsAndHeaders):

                let subwayOrangeTrips = tripsAndHeaders[0].trips
                let subwayOrangeHeader = tripsAndHeaders[0].header
                XCTAssertEqual(subwayOrangeTrips, MBTAViewModel.UpcomingTrips.two(next: 243.0, later: 771.0))
                XCTAssertEqual(subwayOrangeHeader, MBTAViewModel.Header.subway(route: "SomeSubway", direction: "SomeDirection", destination: "SomePlace"))

                let busCT2Trips = tripsAndHeaders[1].trips
                let busCT2Header = tripsAndHeaders[1].header
                XCTAssertEqual(busCT2Trips, MBTAViewModel.UpcomingTrips.none)
                XCTAssertEqual(busCT2Header, MBTAViewModel.Header.bus(route: "SomeBus", destination: "SomePlace"))

                let bus86Trips = tripsAndHeaders[2].trips
                let bus86Header = tripsAndHeaders[2].header
                XCTAssertEqual(bus86Trips, MBTAViewModel.UpcomingTrips.one(next: 1000.0))
                XCTAssertEqual(bus86Header, MBTAViewModel.Header.bus(route: "SomeBus", destination: "SomePlace"))

                let bus90Trips = tripsAndHeaders[3].trips
                let bus90Header = tripsAndHeaders[3].header
                XCTAssertEqual(bus90Trips, MBTAViewModel.UpcomingTrips.none)
                XCTAssertEqual(bus90Header, MBTAViewModel.Header.bus(route: "SomeBus", destination: "SomePlace"))

                let bus91Trips = tripsAndHeaders[4].trips
                let bus91Header = tripsAndHeaders[4].header
                XCTAssertEqual(bus91Trips, MBTAViewModel.UpcomingTrips.one(next: 1661.0))
                XCTAssertEqual(bus91Header, MBTAViewModel.Header.bus(route: "SomeBus", destination: "SomePlace"))
            case .failure(let error):
                XCTFail("got unexpected error: \(error)")
            }
            exp.fulfill()
        }

        waitForExpectations(timeout: 0.1, handler: nil)

    }

}
