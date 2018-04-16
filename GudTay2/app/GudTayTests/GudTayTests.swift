//
//  GudTayTests.swift
//  GudTayTests
//
//  Created by ZevEisenberg on 11/1/16.
//  Copyright © 2017 ZevEisenberg. All rights reserved.
//

@testable import GudTay
import XCTest

class GudTayTests: XCTestCase {
    func testUserDefaults() {
        XCTAssertFalse(UserDefaults.hasOnboarded)
    }
}
