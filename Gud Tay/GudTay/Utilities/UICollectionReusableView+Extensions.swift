//
//  UICollectionReusableView+Extensions.swift
//  Gud Tay
//
//  Created by Zev Eisenberg on 8/18/16.
//  Copyright © 2016 Zev Eisenberg. All rights reserved.
//

import UIKit

extension UICollectionReusableView {

    @nonobjc final class var gudReuseID: String {
        return "\(self)"
    }

}
