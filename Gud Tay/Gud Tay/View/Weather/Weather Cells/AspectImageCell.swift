//
//  AspectImageCell.swift
//  Gud Tay
//
//  Created by Zev Eisenberg on 8/19/16.
//  Copyright © 2016 Zev Eisenberg. All rights reserved.
//

import Anchorage

final class AspectImageCell: WeatherCell {

    // Public Properties

    var image: UIImage? {
        didSet {
            imageView.image = image
            aspectConstraint?.isActive = false
            if let image = image {
                let aspect = image.size.width / image.size.height
                aspectConstraint = (imageView.widthAnchor == imageView.heightAnchor * aspect ~ UILayoutPriorityRequired - 1)
            }
            else {
                aspectConstraint = (imageView.widthAnchor == 0 ~ UILayoutPriority(UILayoutPriorityRequired - 1))
            }
        }
    }

    // Private Properties

    private var aspectConstraint: NSLayoutConstraint?

    private var imageView = UIImageView(axId: "imageView")

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        imageView.edgeAnchors == contentView.edgeAnchors
    }

}
