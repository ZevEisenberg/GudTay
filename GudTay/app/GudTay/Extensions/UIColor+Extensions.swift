//
//  UIColor+Extensions.swift
//  GudTay
//
//  Created by ZevEisenberg on 3/29/17.
//  Copyright © 2017 ZevEisenberg. All rights reserved.
//

import UIKit

extension UIColor {

    /// Get a "highlighted" version of self, with half the 
    /// current color's alpha value.
    var highlighted: UIColor {
        var currentAlpha = CGFloat(0)
        if self.getWhite(nil, alpha: &currentAlpha) {
            return self.withAlphaComponent(currentAlpha / 2)
        }
        else {
            // Fallback to 50% alpha
            return self.withAlphaComponent(0.5)
        }
    }

    static func with(red: UInt8, green: UInt8, blue: UInt8, alpha: UInt8 = 255) -> UIColor {
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: CGFloat(alpha) / 255.0)
    }

}
