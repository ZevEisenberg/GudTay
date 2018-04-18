//
//  CollectionTests.swift
//  UtilitiesTests
//
//  Created by Zev Eisenberg on 4/17/18.
//

import Utilities
import XCTest

class CollectionTests: XCTestCase {

    func testCheckedIndex() {
        let array = [1, 2, 3]
        XCTAssertEqual(array[checked: 0], 1)
        XCTAssertNil(array[checked: 4])
    }

}
