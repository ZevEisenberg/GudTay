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
            case .success(let stop):
                XCTAssertEqual(stop.identifier, "place-sull")
                XCTAssertEqual(stop.name, "Sullivan Square")

                for mode in stop.modes {
                    for route in mode.routes {
                        for direction in route.directions {
                            for trip in direction.trips {
                                XCTAssertTrue(trip.headsign.characters.count > 0)
                            }
                        }
                    }
                }

                let modes = stop.modes
                XCTAssertEqual(modes.count, 2)

                let subway = modes[0]
                XCTAssertEqual(subway.name, "Subway")
                XCTAssertEqual(subway.type, .subway)

                let bus = modes[1]
                XCTAssertEqual(bus.name, "Bus")
                XCTAssertEqual(bus.type, .bus)

                let subwayRoutes = subway.routes
                XCTAssertEqual(subwayRoutes.count, 1)

                let orangeLine = subwayRoutes[0]
                XCTAssertEqual(orangeLine.name, "Orange Line")

                let orangeLineDirections = orangeLine.directions
                XCTAssertEqual(orangeLineDirections.count, 2)

                let orangeSouthbound = orangeLineDirections[0]
                XCTAssertEqual(orangeSouthbound.name, "Southbound")

                let orangeTrips = orangeSouthbound.trips
                XCTAssertEqual(orangeTrips.count, 5)

                let orangeTrip = orangeTrips[0]
                XCTAssertEqual(orangeTrip.identifier, "30838432")
                XCTAssertEqual(orangeTrip.name, "11:06 pm from Oak Grove to Forest Hills Orange Line")
                XCTAssertEqual(orangeTrip.headsign, "Forest Hills")

                let busRoutes = bus.routes
                XCTAssertEqual(busRoutes.count, 8)

                let eightySix = busRoutes[3]
                XCTAssertEqual(eightySix.name, "86")

                let eightySixDirections = eightySix.directions
                XCTAssertEqual(eightySixDirections.count, 2)

                let eightySixInbound = eightySixDirections[1]
                XCTAssertEqual(eightySixInbound.name, "Inbound")

                let eightySixTrips = eightySixInbound.trips
                XCTAssertEqual(eightySixTrips.count, 1)

                let eightySixTrip = eightySixTrips[0]
                XCTAssertEqual(eightySixTrip.identifier, "31233944")
                XCTAssertEqual(eightySixTrip.name, "11:25 pm from Sullivan Station - Upper Busway to Chestnut Hill Ave @ Reservoir Busway")
                XCTAssertEqual(eightySixTrip.headsign, "Reservoir")

                let ninetyOne = busRoutes[5]
                XCTAssertEqual(ninetyOne.name, "91")

                let ninetyOneDirections = ninetyOne.directions
                XCTAssertEqual(ninetyOneDirections.count, 2)

                let ninetyOneInbound = ninetyOneDirections[1]
                XCTAssertEqual(ninetyOneInbound.name, "Inbound")

                let ninetyOneTrips = ninetyOneInbound.trips
                XCTAssertEqual(ninetyOneTrips.count, 1)

                let ninetyOneTrip = ninetyOneTrips[0]
                XCTAssertEqual(ninetyOneTrip.identifier, "31198831")
                XCTAssertEqual(ninetyOneTrip.name, "11:40 pm from Sullivan Station - Upper Busway to Magazine St @ Green St")
                XCTAssertEqual(ninetyOneTrip.headsign, "Central")
            case .failure(let error):
                XCTFail("got unexpected error: \(error)")
            }
            exp.fulfill()
        }

        waitForExpectations(timeout: 0.1, handler: nil)

    }

}
