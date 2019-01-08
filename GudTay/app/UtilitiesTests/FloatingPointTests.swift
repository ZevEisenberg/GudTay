//
//  FloatingPointTests.swift
//  UtilitiesTests
//
//  Created by Zev Eisenberg on 1/7/19.
//

import Utilities
import XCTest

class FloatingPointTests: XCTestCase {

    func testRoundingToNearest() {
        XCTAssertEqual(1.0.roundedToNearest(1.0), 1, accuracy: 0.0000001)
        XCTAssertEqual(1.03.roundedToNearest(1.0), 1, accuracy: 0.0000001)
        XCTAssertEqual(1.3.roundedToNearest(1.0 / 3.0), 1.33333333333, accuracy: 0.0000001)
        XCTAssertEqual(1.3.roundedToNearest(0.5), 1.5, accuracy: 0.0000001)
        XCTAssertEqual(1.2.roundedToNearest(0.5), 1.0, accuracy: 0.0000001)

        XCTAssertEqual(1.0.flooredToNearest(1.0), 1, accuracy: 0.0000001)
        XCTAssertEqual(1.03.flooredToNearest(1.0), 1, accuracy: 0.0000001)
        XCTAssertEqual(1.3.flooredToNearest(1.0 / 3.0), 1.0, accuracy: 0.0000001)
        XCTAssertEqual(1.3.flooredToNearest(0.5), 1.0, accuracy: 0.0000001)
        XCTAssertEqual(1.2.flooredToNearest(0.5), 1.0, accuracy: 0.0000001)

        XCTAssertEqual(1.0.ceiledToNearest(1.0), 1, accuracy: 0.0000001)
        XCTAssertEqual(1.03.ceiledToNearest(1.0), 2, accuracy: 0.0000001)
        XCTAssertEqual(1.3.ceiledToNearest(1.0 / 3.0), 1.33333333333, accuracy: 0.0000001)
        XCTAssertEqual(1.3.ceiledToNearest(0.5), 1.5, accuracy: 0.0000001)
        XCTAssertEqual(1.2.ceiledToNearest(0.5), 1.5, accuracy: 0.0000001)
    }

}
