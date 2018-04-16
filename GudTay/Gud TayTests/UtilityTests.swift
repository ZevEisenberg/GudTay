//
//  UtilityTests.swift
//  Gud Tay
//
//  Created by Zev Eisenberg on 8/2/16.
//  Copyright © 2016 Zev Eisenberg. All rights reserved.
//

import XCTest

class UtilityTests: XCTestCase {

    func testEmptyArray() {
        let empty = [Int]()
        XCTAssertNil(empty[safe: 0])
        XCTAssertNil(empty[safe: 1])
        XCTAssertNil(empty[safe: 100])
        XCTAssertNil(empty[safe: -1])
        XCTAssertNil(empty[safe: -100])
        XCTAssertNil(empty[safe: Int.max])
        XCTAssertNil(empty[safe: Int.min])
    }

    func testArray() {
        let array = [1, 2, 3]
        XCTAssertNil(array[safe: -1])
        XCTAssertEqual(array[safe: 0], 1)
        XCTAssertEqual(array[safe: 1], 2)
        XCTAssertEqual(array[safe: 2], 3)
        XCTAssertNil(array[safe: 3])
        XCTAssertNil(array[safe: 100])
        XCTAssertNil(array[safe: Int.max])
        XCTAssertNil(array[safe: Int.min])
    }

}
