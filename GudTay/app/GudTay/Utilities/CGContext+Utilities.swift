//
//  CGContext+Utilities.swift
//  GudTay
//
//  Created by Zev Eisenberg on 1/14/19.
//

import QuartzCore

extension CGContext {

    func withSavedState(_ block: (CGContext) -> Void) {
        saveGState()
        block(self)
        restoreGState()
    }

}
