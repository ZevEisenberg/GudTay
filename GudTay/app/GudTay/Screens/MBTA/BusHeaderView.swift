//
//  BusHeaderView.swift
//  Gud Tay
//
//  Created by Zev Eisenberg on 7/26/16.
//  Copyright © 2016 Zev Eisenberg. All rights reserved.
//

import Anchorage
import BonMot
import UIKit

final class BusHeaderView: MBTAHeaderView {

    init(route: String, destination: String) {
        super.init(frame: .zero)

        let blueBar = UIView(axId: "blueBar")
        blueBar.backgroundColor = .GudTay.blue
        let yellowBar = UIView(axId: "yellowBar")
        yellowBar.backgroundColor = .GudTay.yellow

        blueBar.heightAnchor == 50.0
        yellowBar.heightAnchor == 20.0

        let destinationTagName = "destination"
        let templateString = "\(route.localizedUppercase) <\(destinationTagName)>to \(destination.localizedUppercase)</\(destinationTagName)>"
        let formatted = templateString.styled(
            with:
            Fonts.MBTA.lineStyle.byAdding(
                .color(.GudTay.white),
                .xmlRules([
                    .style(destinationTagName, Fonts.MBTA.lineStyle.byAdding(.color(.GudTay.translucentWhite))),
                    ])))

        let label = UILabel()
        label.attributedText = formatted

        blueBar.addSubview(label)
        label.leadingAnchor == blueBar.leadingAnchor + 13
        label.centerYAnchor == blueBar.centerYAnchor

        let stackView = UIStackView(arrangedSubviews: [blueBar, yellowBar])
        stackView.axis = .vertical
        addSubview(stackView)
        stackView.edgeAnchors == edgeAnchors
    }

    @available(*, unavailable) override required init(frame: CGRect) {
        fatalError("init(frame:) has not been implemented")
    }

    @available(*, unavailable) required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
