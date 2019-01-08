//
//  Array+Utilities.swift
//  GudTay
//
//  Created by Zev Eisenberg on 4/18/18.
//

import Foundation

extension Array {

    // via https://stackoverflow.com/a/24101606/255489
    var random: Element? {
        if isEmpty { return nil }
        return self[.random(in: 0..<count)]
    }

}
