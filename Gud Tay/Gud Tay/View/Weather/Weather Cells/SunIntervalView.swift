//
//  SunIntervalView.swift
//  Gud Tay
//
//  Created by Zev Eisenberg on 10/10/16.
//  Copyright © 2016 Zev Eisenberg. All rights reserved.
//

import UIKit

final class SunIntervalView: UIView {

    var interval: SolarInterval {
        didSet {
            updateColors(for: interval)
        }
    }

    init(interval: SolarInterval = .day) {
        self.interval = interval
        super.init(frame: .zero)

        updateColors(for: interval)
    }

    @available(*, unavailable) required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }

}

private extension SunIntervalView {

    struct Constants {

        static let dayColors = [
            #colorLiteral(red: 0.9457823634, green: 0.4775958061, blue: 0.3107334077, alpha: 1),
            #colorLiteral(red: 0.7881028056, green: 0.6423463225, blue: 0.3430097401, alpha: 1),
            #colorLiteral(red: 0.5491601825, green: 0.6749857068, blue: 0.6756953597, alpha: 1),
            #colorLiteral(red: 0.3601651634, green: 0.7316058592, blue: 0.8252332109, alpha: 1),
            Colors.day,
            Colors.day,
            Colors.day,
            Colors.day,
            Colors.day,
            #colorLiteral(red: 0.5896936129, green: 0.6227431178, blue: 0.855897367, alpha: 1),
            #colorLiteral(red: 0.7165202457, green: 0.5087971813, blue: 0.855897367, alpha: 1),
            #colorLiteral(red: 0.7916463017, green: 0.2843137383, blue: 0.6883611083, alpha: 1),
            #colorLiteral(red: 0.8521052003, green: 0.217979461, blue: 0.4358110428, alpha: 1),
            ].map { $0.cgColor }

        static let nightColors = [
            #colorLiteral(red: 0.8521052003, green: 0.217979461, blue: 0.4358110428, alpha: 1),
            #colorLiteral(red: 0.6494123936, green: 0.2081551552, blue: 0.5418217182, alpha: 1),
            #colorLiteral(red: 0.4228220406, green: 0.248025836, blue: 0.5151475234, alpha: 1),
            #colorLiteral(red: 0.3309226036, green: 0.2110719979, blue: 0.4729041457, alpha: 1),
            Colors.night,
            Colors.night,
            Colors.night,
            Colors.night,
            Colors.night,
            #colorLiteral(red: 0.3506155312, green: 0.2267658114, blue: 0.4926431775, alpha: 1),
            #colorLiteral(red: 0.5382626653, green: 0.1942460537, blue: 0.5112031102, alpha: 1),
            #colorLiteral(red: 0.6770273447, green: 0.3034084737, blue: 0.2895900309, alpha: 1),
            #colorLiteral(red: 0.9457823634, green: 0.4775958061, blue: 0.3107334077, alpha: 1),
            ].map { $0.cgColor }

    }

    func updateColors(for interval: SolarInterval) {
        accessibilityIdentifier = "\(interval)View"
        let gradientLayer = forceCast(layer, as: CAGradientLayer.self)

        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.colors = {
            switch interval {
            case .day: return Constants.dayColors
            case .night: return Constants.nightColors
            }
        }()
    }

}
