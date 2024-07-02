//
//  GudTayView.swift
//  Gud Tay
//
//  Created by Zev Eisenberg on 7/26/16.
//  Copyright © 2016 Zev Eisenberg. All rights reserved.
//

import UIKit
import Anchorage

final class GudTayView: GridView {

    override init(frame: CGRect) {
        super.init(frame: frame)

        let imageView = UIImageView(image: Asset.Gud_Tay.image)
        addSubview(imageView)
        imageView.edgeAnchors == edgeAnchors
        imageView.contentMode = .scaleAspectFit
    }

}
