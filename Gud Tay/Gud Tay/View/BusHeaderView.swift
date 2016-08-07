//
//  BusHeaderView.swift
//  Gud Tay
//
//  Created by Zev Eisenberg on 7/26/16.
//  Copyright © 2016 Zev Eisenberg. All rights reserved.
//

import Anchorage
import BonMot

final class BusHeaderView: MBTAHeaderView {

    init(route: String, destination: String) {
        super.init(frame: .zero)

        let blueBar = UIView(axId: "blueBar")
        blueBar.backgroundColor = Colors.blue
        let yellowBar = UIView(axId: "yellowBar")
        yellowBar.backgroundColor = Colors.yellow

        blueBar.heightAnchor == 50.0
        yellowBar.heightAnchor == 20.0

        let destinationTagName = "destination"
        let templateString = "\(route.localizedUppercase) <\(destinationTagName)>to \(destination.localizedUppercase)</\(destinationTagName)>"
        let chain = Fonts.lineChain
            .color(Colors.white)
            .string(templateString)
            .tagStyles([
                destinationTagName: Fonts.lineChain.color(Colors.translucentWhite),
                ])

        let label = UILabel()
        label.attributedText = chain.attributedString

        blueBar.addSubview(label)
        label.leadingAnchor == blueBar.leadingAnchor + 13
        label.centerYAnchor == blueBar.centerYAnchor

        let stackView = UIStackView(arrangedSubviews: [blueBar, yellowBar])
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
