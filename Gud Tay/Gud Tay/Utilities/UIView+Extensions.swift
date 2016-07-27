//
//  UIView+Extensions.swift
//  Gud Tay
//
//  Created by Zev Eisenberg on 7/26/16.
//  Copyright © 2016 Zev Eisenberg. All rights reserved.
//

import UIKit

extension UIView {

    convenience init(axId: String) {
        self.init()
        self.accessibilityIdentifier = axId
    }

}
