//
//  Colors.swift
//  Gud Tay
//
//  Created by Zev Eisenberg on 8/7/16.
//  Copyright © 2016 Zev Eisenberg. All rights reserved.
//

import UIKit

struct Colors {

    static let orange = #colorLiteral(red: 0.9098039216, green: 0.4823529412, blue: 0, alpha: 1)
    static let blue = #colorLiteral(red: 0.1490196078, green: 0.4549019608, blue: 0.7607843137, alpha: 1)
    static let yellow = #colorLiteral(red: 0.9921568627, green: 0.7843137255, blue: 0.2588235294, alpha: 1)
    static let darkGray = #colorLiteral(red: 0.262745098, green: 0.262745098, blue: 0.262745098, alpha: 1)
    static let translucentWhite = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.6)
    static let white = #colorLiteral(red: 1, green: 0.99997437, blue: 0.9999912977, alpha: 1)
    static let black = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)

    static var random: UIColor {
        return UIColor(
            red: CGFloat(arc4random_uniform(255)) / 255.0,
            green: CGFloat(arc4random_uniform(255)) / 255.0,
            blue: CGFloat(arc4random_uniform(255)) / 255.0,
            alpha: 1.0
        )
    }

}
