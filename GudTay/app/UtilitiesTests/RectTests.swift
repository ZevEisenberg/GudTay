//
//  RectTests.swift
//  UtilitiesTests
//
//  Created by Zev Eisenberg on 1/7/19.
//

import Utilities
import XCTest

class RectTests: XCTestCase {

    func testRectIntegralization() {
        XCTAssertEqual(
            CGRect(
                x: 0.333333,
                y: 1.2345,
                width: 4.142857,
                height: 2.999
                ).integralizedToScreenPixels(withScale: 2),
            CGRect(
                x: 0,
                y: 1,
                width: 4.5,
                height: 3
            )
        )
    }

}
