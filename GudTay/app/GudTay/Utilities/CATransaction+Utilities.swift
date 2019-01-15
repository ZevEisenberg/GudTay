//
//  CATransaction+Utilities.swift
//  GudTay
//
//  Created by Zev Eisenberg on 1/14/19.
//

import QuartzCore

extension CATransaction {

    static func performWithoutAnimation(_ block: () -> Void) {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        block()
        CATransaction.commit()
    }

}
