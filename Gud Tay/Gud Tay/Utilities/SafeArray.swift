//
//  SafeArray.swift
//  Gud Tay
//
//  Created by Zev Eisenberg on 8/2/16.
//  Copyright © 2016 Zev Eisenberg. All rights reserved.
//

// via http://stackoverflow.com/a/30593673/255489

extension RandomAccessCollection {
    /// Returns the element at the specified index iff it is within bounds, otherwise nil.
    public subscript(safe index: Index) -> Iterator.Element? {
        guard index >= startIndex && index < endIndex else {
            return nil
        }

        return self[index]
    }
}
