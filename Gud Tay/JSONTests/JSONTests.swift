//
//  JSONTests.swift
//  JSONTests
//
//  Created by Zev Eisenberg on 2/28/17.
//  Copyright © 2017 Zev Eisenberg. All rights reserved.
//

import XCTest
@testable import JSON

class JSONTests: XCTestCase {

    func testJson() throws {
        let url = try assertNotNilAndUnwrap(Bundle(for: JSONTests.self).url(forResource: "tests", withExtension: "json"))
        let data = try assertNotNilAndUnwrap(Data(contentsOf: url))
        let json = try JSONSerialization.jsonObject(with: data, options: [])
        let jsonDict = try assertNotNilAndUnwrap(json as? [String: Any])

        let tripIdString: String = try jsonDict.value(key: "trip_id_string")
        XCTAssertEqual(tripIdString, "30838431")

        let tripIdNumber: Int = try jsonDict.value(key: "trip_id_number")
        XCTAssertEqual(tripIdNumber, 30838431)

        do {
            let malformedNumber: Int = try jsonDict.value(key: "trip_id_string")
            XCTAssertEqual(malformedNumber, 30838431)
        }
        catch let e as JSONError {
            switch e {
            case .generic, .malformedOrMissingKey:
                XCTFail("Threw incorrect error: \(e)")
            case .malformedValue(let key, let value, let parent):
                XCTAssertEqual(key, "trip_id_string")
                let value: String = try assertNotNilAndUnwrap(value as? String)
                XCTAssertEqual(value, "30838431")
                let parentDict = try assertNotNilAndUnwrap(parent as? [String: Any])
                XCTAssertEqual(parentDict.count, 10)
            }
        }
        catch {
            XCTFail("Got unexpected error \(error)")
        }

        let date: Date = try jsonDict.date(key: "sch_arr_dt")
        XCTAssertEqual(date, Date(timeIntervalSince1970: 1469503560))

        let nullWithPresentKey: String? = jsonDict.optionalValue(key: "null_thing")
        XCTAssertNil(nullWithPresentKey)

        let nullWithAbsentKey: Int? = jsonDict.optionalValue(key: "missing_key")
        XCTAssertNil(nullWithAbsentKey)

        do {
            let unexpectedlyAbsentKey: String = try jsonDict.value(key: "missing_key")
            XCTFail("Unexpectedly got value that was supposed to be missing: \(unexpectedlyAbsentKey)")
        }
        catch let e as JSONError {
            switch e {
            case .generic, .malformedValue:
                XCTFail("Threw incorrect error: \(e)")
            case .malformedOrMissingKey(let key, let parent):
                XCTAssertEqual(key, "missing_key")
                let parentDict = try assertNotNilAndUnwrap(parent as? [String: Any])
                XCTAssertEqual(parentDict.count, 10)
            }
        }
        catch {
            XCTFail("Got unexpected error \(error)")
        }

        let subDict: [String: Any] = try jsonDict.value(key: "vehicle")
        XCTAssertEqual(subDict.count, 5)

        let id: String = try subDict.value(key: "vehicle_id")
        XCTAssertEqual(id, "544761EF")
        let lat: Double = try subDict.value(key: "vehicle_lat")
        XCTAssertEqual(lat, 42.43773, accuracy: 0.0001)
    }

}
