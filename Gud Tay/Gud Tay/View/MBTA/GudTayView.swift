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

    typealias TapHandler = () -> ()

    fileprivate let tapHandler: TapHandler

    init(tapHandler: TapHandler) {
        self.tapHandler = tapHandler
        super.init(frame: .zero)

        let imageView = UIImageView(image: Asset.Gud_Tay.image)
        addSubview(imageView)
        imageView.edgeAnchors == edgeAnchors
        imageView.contentMode = .scaleAspectFit

        let tap = UITapGestureRecognizer(target: self, action: #selector(GudTayView.tapped(sender:)))
        addGestureRecognizer(tap)
    }

}

private extension GudTayView {

    @objc func tapped(sender: UITapGestureRecognizer) {
        tapHandler()
    }

}
