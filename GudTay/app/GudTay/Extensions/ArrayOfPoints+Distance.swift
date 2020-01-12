//
//  ArrayOfPoints+Distance.swift
//  GudTay
//
//  Created by Zev Eisenberg on 1/1/19.
//

import CoreGraphics

extension CGPoint {

    func distance(to other: CGPoint) -> CGFloat {
        hypot(other.x - x, other.y - y)
    }

}

extension Array where Element == CGPoint {

    var movesMoreThanOnePt: Bool {
        guard
            !isEmpty,
            let first = first,
            let last = last
            else { preconditionFailure("Doesn't make sense to ask an empty array whether it has moved") }

        return first.distance(to: last) > 1 || contains { $0.distance(to: first) > 1 }
    }

}
