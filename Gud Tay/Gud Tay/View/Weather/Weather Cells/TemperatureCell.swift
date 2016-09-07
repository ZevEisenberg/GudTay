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

    var temps: (current: Double, high: Double, low: Double)? {
        didSet {
            currentLabel.attributedText = Fonts.Weather.currentTempChain
                .string(String(format: "%.0f°", temps?.current ?? "--"))
                .attributedString

            lowLabel.attributedText = Fonts.Weather.tempRangeChain
                .string(String(format: "%.0f°", temps?.low ?? "--"))
                .attributedString

            highLabel.attributedText = Fonts.Weather.tempRangeChain
                .string(String(format: "%.0f°", temps?.high ?? "--"))
                .attributedString
        }
    }

    // Private Properties

    let currentLabel: UILabel = {
        let label = UILabel(axId: "currentLabel")
        label.setContentHuggingPriority(UILayoutPriorityDefaultLow - 1, for: .vertical)
        return label
    }()
    let highLabel = UILabel(axId: "highLabel")
    let lowLabel = UILabel(axId: "lowLabel")

    override init(frame: CGRect) {
        super.init(frame: frame)

        let rangeStackView = UIStackView(axId: "rangeStackView")
        rangeStackView.addArrangedSubview(lowLabel)
        rangeStackView.addArrangedSubview(highLabel)
        rangeStackView.axis = .horizontal
        rangeStackView.distribution = .fillEqually
        rangeStackView.alignment = .firstBaseline

        let mainStackView = UIStackView(axId: "mainStackView")
        mainStackView.addArrangedSubview(currentLabel)
        mainStackView.addArrangedSubview(rangeStackView)
        mainStackView.axis = .vertical
        mainStackView.distribution = .fill

        contentView.addSubview(mainStackView)

        mainStackView.edgeAnchors == contentView.edgeAnchors + 5.0
    }

}