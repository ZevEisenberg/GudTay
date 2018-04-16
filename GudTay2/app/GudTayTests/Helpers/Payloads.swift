//
//  Payloads.swift
//  GudTay
//
//  Created by ZevEisenberg on 11/3/16.
//  Copyright © 2017 ZevEisenberg. All rights reserved.
//

import Foundation
@testable import GudTay
import Services

private final class Dummy {}

private func testingJSON(named name: String) -> Data {
    // swiftlint:disable:next force_try
    return try! Data(contentsOf: Bundle(for: Dummy.self).url(forResource: name, withExtension: "json")!)
}

enum Payloads {
    enum MBTA {
        static let predictions = testingJSON(named: "predictions")
    }

}
