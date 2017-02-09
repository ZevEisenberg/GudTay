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

    typealias TapHandler = () -> Void

    fileprivate let tapHandler: TapHandler

    init(tapHandler: @escaping TapHandler) {
        self.tapHandler = tapHandler
        super.init(frame: .zero)

        let image = #imageLiteral(resourceName: "gud-tay")
        let imageView = UIImageView(image: image)
        addSubview(imageView)
        imageView.centerAnchors == centerAnchors
        imageView.edgeAnchors >= edgeAnchors
        imageView.setContentHuggingPriority(UILayoutPriorityRequired, for: .horizontal)
        imageView.setContentHuggingPriority(UILayoutPriorityRequired, for: .vertical)
        let aspect = image.size.width / image.size.height
        imageView.widthAnchor == imageView.heightAnchor * aspect

        let tap = UITapGestureRecognizer(target: self, action: #selector(GudTayView.tapped(sender:)))
        addGestureRecognizer(tap)
    }

}

private extension GudTayView {

    @objc func tapped(sender: UITapGestureRecognizer) {
        tapHandler()
    }

}
