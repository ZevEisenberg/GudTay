//
//  BinaryFloatingPoint+Utilities.swift
//  Utilities
//
//  Created by Zev Eisenberg on 1/7/19.
//

extension BinaryFloatingPoint {

    public func roundedToNearest<I: BinaryFloatingPoint>(_ increment: I) -> Self {
        precondition(increment > 0)
        return roundedToNearest(increment, using: .toNearestOrAwayFromZero)
    }

    public func flooredToNearest<I: BinaryFloatingPoint>(_ increment: I) -> Self {
        precondition(increment > 0)
        return roundedToNearest(increment, using: .towardZero)
    }

    public func ceiledToNearest<I: BinaryFloatingPoint>(_ increment: I) -> Self {
        precondition(increment > 0)
        return roundedToNearest(increment, using: self > 0 ? .up : .down)
    }

}

private extension BinaryFloatingPoint {

    func roundedToNearest<I: BinaryFloatingPoint>(_ increment: I, using rule: FloatingPointRoundingRule) -> Self {
        precondition(increment > 0)
        return (self / Self(increment)).rounded(rule) * Self(increment)
    }

}