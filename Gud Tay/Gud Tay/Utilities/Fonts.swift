//
//  Fonts.swift
//  Gud Tay
//
//  Created by Zev Eisenberg on 8/7/16.
//  Copyright © 2016 Zev Eisenberg. All rights reserved.
//

import BonMot

struct Fonts {

    private static let baseMinutesChain = BONChain()
        .pointTracking(-2.68)
        .figureSpacing(.proportional)

    static let nextMinutesChain = baseMinutesChain
        .font(UIFont(name: "HelveticaNeue-Medium", size: 120.0)!)

    static let laterMinutesChain = baseMinutesChain
        .font(UIFont(name: "HelveticaNeue", size: 120.0)!)

    static let minutesSubtitleChain = BONChain()
        .font(UIFont(name: "HelveticaNeue-Medium", size: 28.0)!)

    static let lineChain = BONChain()
        .font(UIFont(name: "HelveticaNeue-Medium", size: 44.0))
        .pointTracking(-0.9)

    static let destinationPrefixChain = BONChain()
        .font(UIFont(name: "HelveticaNeue-Medium", size: 13.5)!)

    static let destinationChain = BONChain()
        .font(UIFont(name: "HelveticaNeue-Bold", size: 13.5)!)

}
