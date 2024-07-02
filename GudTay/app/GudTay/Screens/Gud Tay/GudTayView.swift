//
//  GudTayView.swift
//  GudTay
//
//  Created by Zev Eisenberg on 7/26/16.
//  Copyright © 2016 Zev Eisenberg. All rights reserved.
//

import Anchorage
import UIKit

final class GudTayView: GridView {

    typealias TapHandler = () -> Void

    private let tapHandler: TapHandler

    init(tapHandler: @escaping TapHandler) {
        self.tapHandler = tapHandler
        super.init(frame: .zero)

        let tap = UITapGestureRecognizer(target: self, action: #selector(GudTayView.tapped(sender:)))
        addGestureRecognizer(tap)

        let gudTayImageView = UIImageView(image: UIImage(resource: .gudTay))
        gudTayImageView.contentMode = .scaleAspectFit
        contentView.addSubview(gudTayImageView)
        gudTayImageView.verticalAnchors == verticalAnchors + 5
        gudTayImageView.leadingAnchor == leadingAnchor
        gudTayImageView.setContentHuggingPriority(.defaultLow, for: .horizontal)

        let clock = ClockView()
        contentView.addSubview(clock)
        clock.leadingAnchor == gudTayImageView.trailingAnchor
        clock.trailingAnchor == trailingAnchor - 22
        clock.centerYAnchor == centerYAnchor
    }

}

private extension GudTayView {

    @objc func tapped(sender: UITapGestureRecognizer) {
        tapHandler()
    }

}
