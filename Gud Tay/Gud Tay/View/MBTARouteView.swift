//
//  MBTARouteView.swift
//  Gud Tay
//
//  Created by Zev Eisenberg on 7/26/16.
//  Copyright © 2016 Zev Eisenberg. All rights reserved.
//

import UIKit

final class MBTARouteView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = UIColor(red: CGFloat(arc4random_uniform(100)) / 100.0,
                                  green: CGFloat(arc4random_uniform(100)) / 100.0,
                                  blue: CGFloat(arc4random_uniform(100)) / 100.0,
                                  alpha: 1)
    }

    @available(*, unavailable) required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
