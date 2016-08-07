//
//  Fonts.swift
//  Gud Tay
//
//  Created by Zev Eisenberg on 8/7/16.
//  Copyright © 2016 Zev Eisenberg. All rights reserved.
//

import BonMot

struct Fonts {

    static let minutesFont = UIFont(name: "HelveticaNeue-Medium", size: 120.0)!

    static let lineChain = BONChain()
        .font(UIFont(name: "HelveticaNeue-Medium", size: 44.0))
        .pointTracking(-0.9)

    static let minutesLabelFont = UIFont(name: "HelveticaNeue-Medium", size: 28.0)!

    static let destinationPrefixChain = BONChain()
        .font(UIFont(name: "HelveticaNeue-Medium", size: 13.5)!)

    static let destinationChain = BONChain()
        .font(UIFont(name: "HelveticaNeue-Bold", size: 13.5)!)

}
