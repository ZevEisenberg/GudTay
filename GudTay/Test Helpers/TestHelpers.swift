//
//  TestHelpers.swift
//  Gud Tay
//
//  Created by Zev Eisenberg on 2/28/16.
//  Copyright © 2016 Zev Eisenberg. All rights reserved.
//

import XCTest

extension XCTestCase {

    struct UnexpectedNilError: Error {}
    func assertNotNilAndUnwrap<T>(_ variable: T?, message: String = "Unexpected nil variable", file: StaticString = #file, line: UInt = #line) throws -> T {
        guard let variable = variable else {
            XCTFail(message, file: file, line: line)
            throw UnexpectedNilError()
        }
        return variable
    }

}
