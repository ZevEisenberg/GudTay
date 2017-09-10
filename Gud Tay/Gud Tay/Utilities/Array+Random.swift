//
//  Array+Random.swift
//  Gud Tay
//
//  Created by Zev Eisenberg on 9/10/17.
//  Copyright © 2017 Zev Eisenberg. All rights reserved.
//

extension Array {

    // via https://stackoverflow.com/a/24101606/255489
    var random: Element? {
        if isEmpty { return nil }
        let index = Int(arc4random_uniform(UInt32(count)))
        return self[index]
    }

}
