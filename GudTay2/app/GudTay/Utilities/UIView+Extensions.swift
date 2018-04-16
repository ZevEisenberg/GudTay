//
//  UIView+Extensions.swift
//  GudTay
//
//  Created by Zev Eisenberg on 4/16/18.
//

import UIKit

extension UIView {

    convenience init(axId: String) {
        self.init()
        self.accessibilityIdentifier = axId
    }

}
