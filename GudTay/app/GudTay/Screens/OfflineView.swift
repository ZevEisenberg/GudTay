//
//  OfflineView.swift
//  GudTay
//
//  Created by Zev Eisenberg on 3/14/20.
//

import Anchorage
import UIKit
import Utilities

final class OfflineView: UIView {

    private let imageView = with(UIImageView(image: Asset.wifi.image)) {
        $0.setContentHuggingPriority(.required, for: .vertical)
        $0.setContentHuggingPriority(.required, for: .horizontal)
        $0.clipsToBounds = false
        $0.layer.shadowColor = Asset.black.color.cgColor
        $0.layer.shadowOpacity = 0.7
        $0.layer.shadowRadius = 30
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        // Allow tap-throughs to elements behind
        isUserInteractionEnabled = false

        backgroundColor = Asset.black.color.withAlphaComponent(0.4)

        addSubview(imageView)

        imageView.centerAnchors == centerAnchors
        imageView.edgeAnchors >= edgeAnchors
    }

    @available(*, unavailable) required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
