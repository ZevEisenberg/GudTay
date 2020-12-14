//
//  TemperatureCell.swift
//  Gud Tay
//
//  Created by Zev Eisenberg on 8/18/16.
//  Copyright © 2016 Zev Eisenberg. All rights reserved.
//

import Anchorage
import UIKit

final class TemperatureCell: WeatherCell {

    // Public Properties

    var temps: (current: Double, high: Double, low: Double)? {
        didSet {
            currentLabel.attributedText = String(format: "%.0f°", temps?.current ?? "--").styled(with: Fonts.Weather.currentTempStyle)

            lowLabel.attributedText = String(format: "%.0f°", temps?.low ?? "--").styled(with: Fonts.Weather.tempRangeStyle)

            highLabel.attributedText = String(format: "%.0f°", temps?.high ?? "--").styled(with: Fonts.Weather.tempRangeStyle)
        }
    }

    // Private Properties

    let currentLabel: UILabel = {
        let label = UILabel(axId: "currentLabel")
        label.setContentHuggingPriority(.defaultLow - 1, for: .vertical)
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

        Anchorage.batch { // batch so we can modify priorities before activating constraints
            let edgeConstraints = mainStackView.edgeAnchors == contentView.edgeAnchors + 5.0
            edgeConstraints.trailing.priority = .required - 1
            edgeConstraints.bottom.priority = .required - 1
        }
    }

}
