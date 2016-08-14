//
//  CloseEnough.swift
//  Gud Tay
//
//  Created by Zev Eisenberg on 8/14/16.
//  Copyright © 2016 Zev Eisenberg. All rights reserved.
//

extension BinaryFloatingPoint {

    func isPracticallyZero(tolerance: Double = 0.0001) -> Bool {
        return self < Self(tolerance) && self > Self(-tolerance)
    }

}
