//
//  BinaryFloatingPoint+Utilities.swift
//  Services
//
//  Created by Zev Eisenberg on 4/18/18.
//

public extension BinaryFloatingPoint {

    func isPracticallyZero(tolerance: Self = 0.0001) -> Bool {
        abs(self) < tolerance
    }

}
