//
//  AspectImageCell.swift
//  Gud Tay
//
//  Created by Zev Eisenberg on 8/19/16.
//  Copyright © 2016 Zev Eisenberg. All rights reserved.
//

import Anchorage
import UIKit

final class AspectImageCell: WeatherCell {

    // Public Properties

    /// A stack of images, arranged back-to-front.
    /// All images are assumed to be of the same aspect ratio; the aspect
    /// ratio of the first (back-most) image is used for constraint purposes.
    var images: [UIImage] = [] {
        didSet {
            imageViews.forEach { $0.removeFromSuperview() }
            imageViews = images.map(UIImageView.init)
            imageViews.forEach(contentView.addSubview)
            imageViews.forEach {
                $0.edgeAnchors == contentView.edgeAnchors
            }
            aspectConstraint?.isActive = false
            if let image = images.first, let imageView = imageViews.first {
                let aspect = image.size.width / image.size.height
                aspectConstraint = (imageView.widthAnchor == imageView.heightAnchor * aspect ~ .required - 1)
            }
            else {
                // Can't use Anchorage to adjust the conentView, since doing so
                // will also set translatesAutoresizingMaskIntoConstraints to
                // false, and we shouldn't do that on views we don't own.
                aspectConstraint = contentView.widthAnchor.constraint(equalToConstant: 0)
                aspectConstraint?.priority = .required - 1
                aspectConstraint?.isActive = true
            }
        }
    }

    // Private Properties

    private var aspectConstraint: NSLayoutConstraint?

    private var imageViews: [UIImageView] = []

}
