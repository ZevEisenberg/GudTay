//
//  WeatherCell.swift
//  Gud Tay
//
//  Created by Zev Eisenberg on 8/18/16.
//  Copyright © 2016 Zev Eisenberg. All rights reserved.
//

import UIKit
import Anchorage

class WeatherCell: UICollectionViewCell {

    // Public Properties

    var pinnedHeight: CGFloat = 1.0 {
        didSet {
            heightConstraint?.constant = pinnedHeight
        }
    }

    // Private Properties

    private var heightConstraint: NSLayoutConstraint?

    override init(frame: CGRect) {
        super.init(frame: frame)
        heightConstraint = (contentView.heightAnchor == pinnedHeight)
    }

    @available(*, unavailable) required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
