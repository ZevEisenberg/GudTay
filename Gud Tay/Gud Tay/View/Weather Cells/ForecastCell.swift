//
//  ForecastCell.swift
//  Gud Tay
//
//  Created by Zev Eisenberg on 8/19/16.
//  Copyright © 2016 Zev Eisenberg. All rights reserved.
//

import Anchorage

final class ForecastCell: WeatherCell {

    // Public Properties

    var model: (time: Date, icon: Icon?, temp: Double, precipProbability: Double?)? {
        didSet {
            if let model = model {
                let dateString = ForecastCell.dateFormatter.string(from: model.time)
                timeLabel.attributedText = Fonts.Weather.timeChain
                    .string(dateString)
                    .attributedString

                if let probability = model.precipProbability, !probability.isPracticallyZero() {
                    precipProbabilityLabel.attributedText = Fonts.Weather.precipProbabilityChain
                        .string(String(format: "%.0f%%", probability * 100.0))
                        .attributedString
                    precipProbabilityLabel.alpha = 1.0
                }
                else {
                    precipProbabilityLabel.attributedText = Fonts.Weather.precipProbabilityChain
                        .string("foo")
                        .attributedString
                    precipProbabilityLabel.alpha = 0.0
                }

                iconImageView.image = model.icon?.image

                tempLabel.attributedText = Fonts.Weather.tempForecastChain
                    .string(String(format: "%.0f°", model.temp))
                    .attributedString
            }
            else {
                timeLabel.text = nil
                precipProbabilityLabel.text = nil
                iconImageView.image = nil
                tempLabel.text = nil
            }
        }
    }

    static let preferredWidth: CGFloat = 67.0

    // Private Properties

    let timeLabel: UILabel = {
        let label = UILabel(axId: "timeLabel")
        label.setContentCompressionResistancePriority(UILayoutPriorityRequired, for: .vertical)
        return label
    }()

    let precipProbabilityLabel: UILabel = {
        let label = UILabel(axId: "precipProbabilityLabel")
        label.setContentCompressionResistancePriority(UILayoutPriorityRequired, for: .vertical)
        return label
    }()

    let iconImageView: UIImageView = {
        let imageView = UIImageView(axId: "iconImageView")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    let tempLabel = UILabel(axId: "tempLabel")

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        formatter.calendar = Calendar.current
        formatter.dateFormat = "ha"
        return formatter
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .clear

        contentView.layoutMargins = UIEdgeInsets(top: 10.0, left: 0.0, bottom: 20.0, right: 0.0)

        let stackView = UIStackView(arrangedSubviews: [
            timeLabel,
            precipProbabilityLabel,
            iconImageView,
            tempLabel,
            ])
        stackView.axis = .vertical
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.preservesSuperviewLayoutMargins = true

        contentView.addSubview(stackView)
        stackView.edgeAnchors == contentView.edgeAnchors

        contentView.widthAnchor == ForecastCell.preferredWidth
    }

}
