//
//  RandomAccessCollection+Utilities.swift
//  Utilities
//
//  Created by Zev Eisenberg on 4/17/18.
//

// via http://stackoverflow.com/a/30593673/255489

extension RandomAccessCollection {
    /// Returns the element at the specified index iff it is within bounds, otherwise nil.
    public subscript(checked index: Index) -> Iterator.Element? {
        guard index >= startIndex && index < endIndex else {
            return nil
        }

        return self[index]
    }
}
