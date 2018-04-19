//
//  BinaryFloatingPoint+Utilities.swift
//  Services
//
//  Created by Zev Eisenberg on 4/18/18.
//

extension BinaryFloatingPoint {

    public func isPracticallyZero(tolerance: Self = 0.0001) -> Bool {
        return abs(self) < tolerance
    }

}
