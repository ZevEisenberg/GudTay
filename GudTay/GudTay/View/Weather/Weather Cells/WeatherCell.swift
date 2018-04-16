//
//  WeatherCell.swift
//  Gud Tay
//
//  Created by Zev Eisenberg on 8/18/16.
//  Copyright © 2016 Zev Eisenberg. All rights reserved.
//

import Anchorage
import UIKit

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
        // Don't use Anchorage so we avoid affecting translatesAutoresizingMaskIntoConstraints
        heightConstraint = contentView.heightAnchor.constraint(equalToConstant: pinnedHeight)
        heightConstraint?.isActive = true
    }

    @available(*, unavailable) required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
