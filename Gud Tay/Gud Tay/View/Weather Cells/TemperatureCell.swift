//
//  TemperatureCell.swift
//  Gud Tay
//
//  Created by Zev Eisenberg on 8/18/16.
//  Copyright © 2016 Zev Eisenberg. All rights reserved.
//

import Anchorage

final class TemperatureCell: WeatherCell {

    // Public Properties

    var currentTemp: Double? {
        didSet {
            currentLabel.attributedText = Fonts.Weather.currentTempChain
                .string(String(format: "%.0f°", currentTemp ?? "--"))
                .attributedString
        }
    }

    // Private Properties

    let currentLabel: UILabel = {
        let label = UILabel(axId: "currentLabel")
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(currentLabel)

        currentLabel.edgeAnchors == contentView.edgeAnchors + 5.0
    }

}
