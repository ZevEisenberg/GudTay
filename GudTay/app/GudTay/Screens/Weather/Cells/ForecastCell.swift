//
//  ForecastCell.swift
//  Gud Tay
//
//  Created by Zev Eisenberg on 8/19/16.
//  Copyright © 2016 Zev Eisenberg. All rights reserved.
//

import Anchorage
import Services

final class ForecastCell: WeatherCell {

    // Public Properties

    var model: (time: Date, icon: UIImage?, temp: Double, precipProbability: Double?)? {
        didSet {
            if let model = model {
                let dateString = ForecastCell.dateFormatter.string(from: model.time)
                timeLabel.attributedText = dateString.styled(with: Fonts.Weather.timeStyle)

                if let probability = model.precipProbability, !probability.isPracticallyZero() {
                    precipProbabilityLabel.attributedText = String(format: "%.0f%%", probability * 100.0).styled(with: Fonts.Weather.precipProbabilityStyle)
                    precipProbabilityLabel.alpha = 1.0
                }
                else {
                    precipProbabilityLabel.attributedText = "foo".styled(with: Fonts.Weather.precipProbabilityStyle)
                    precipProbabilityLabel.alpha = 0.0
                }

                iconImageView.image = model.icon

                tempLabel.attributedText = String(format: "%.0f°", model.temp).styled(with: Fonts.Weather.tempForecastStyle)
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
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        return label
    }()

    let precipProbabilityLabel: UILabel = {
        let label = UILabel(axId: "precipProbabilityLabel")
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        return label
    }()

    let iconImageView: UIImageView = {
        let imageView = UIImageView(axId: "iconImageView")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    let tempLabel: UILabel = {
        let label = UILabel(axId: "tempLabel")
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        return label
    }()

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

        // Don't use Anchorage so we avoid affecting translatesAutoresizingMaskIntoConstraints
        let constraint = contentView.widthAnchor.constraint(equalToConstant: ForecastCell.preferredWidth)
        constraint.priority = UILayoutPriority(UILayoutPriority.required.rawValue - 1)
        constraint.isActive = true
    }

}
