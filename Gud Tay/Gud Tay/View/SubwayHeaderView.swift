//
//  SubwayHeaderView.swift
//  Gud Tay
//
//  Created by Zev Eisenberg on 7/26/16.
//  Copyright © 2016 Zev Eisenberg. All rights reserved.
//

import Anchorage
import BonMot

final class SubwayHeaderView: MBTAHeaderView {

    init(route: String, direction: String, destination: String) {
        super.init(frame: .zero)

        let orangeBar = UIView(axId: "orangeBar")
        orangeBar.backgroundColor = Colors.orange
        let whiteBar = UIView(axId: "whiteBar")
        whiteBar.backgroundColor = Colors.white
        let hairline = HairlineView(axis: .horizontal, thickness: 1.0, color: Colors.black)

        orangeBar.heightAnchor == 50.0
        whiteBar.heightAnchor == 50.0

        let routeChain = Fonts.lineChain.string(route.localizedUppercase).color(Colors.white)
        let directionChain = Fonts.lineChain.string(direction.localizedUppercase).color(Colors.black)

        let destinationTagName = "destination"
        let destinationTemplate = "TO <\(destinationTagName)>\(destination.localizedUppercase)</\(destinationTagName)>"
        let destinationChain = Fonts.destinationPrefixChain
            .color(Colors.black)
            .string(destinationTemplate)
            .tagStyles([
                destinationTagName: Fonts.destinationChain.color(Colors.black),
                ])

        let routeLabel = UILabel(axId: "routeLabel")
        routeLabel.attributedText = routeChain.attributedString

        let directionLabel = UILabel(axId: "directionLabel")
        directionLabel.attributedText = directionChain.attributedString

        let destinationLabel = UILabel(axId: "destinationLabel")
        destinationLabel.attributedText = destinationChain.attributedString

        orangeBar.addSubview(routeLabel)
        whiteBar.addSubview(directionLabel)
        whiteBar.addSubview(destinationLabel)

        routeLabel.leadingAnchor == orangeBar.leadingAnchor + 9.0
        routeLabel.centerYAnchor == orangeBar.centerYAnchor

        directionLabel.leadingAnchor == whiteBar.leadingAnchor + 9.0
        directionLabel.centerYAnchor == whiteBar.centerYAnchor

        destinationLabel.trailingAnchor == whiteBar.trailingAnchor - 11.0
        BONTextAlignmentConstraint(item: directionLabel,
                                   attribute: .capHeight,
                                   relatedBy: .equal,
                                   toItem: destinationLabel,
                                   attribute: .capHeight).isActive = true

        let stackView = UIStackView(arrangedSubviews: [orangeBar, whiteBar, hairline])
        stackView.axis = .vertical
        addSubview(stackView)
        stackView.edgeAnchors == edgeAnchors
    }

    @available(*, unavailable) required override init(frame: CGRect) {
        fatalError("init(frame:) has not been implemented")
    }

    @available(*, unavailable) required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
