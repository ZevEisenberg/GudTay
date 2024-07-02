//
//  Fonts.swift
//  Gud Tay
//
//  Created by Zev Eisenberg on 8/7/16.
//  Copyright © 2016 Zev Eisenberg. All rights reserved.
//

import BonMot
import UIKit

enum Fonts {

    enum MBTA {

        private static let baseMinutesStyle = StringStyle(
            .tracking(.point(-2.68)),
            .numberSpacing(.proportional))

        static let nextMinutesStyle = baseMinutesStyle.byAdding(
            .font(UIFont(name: "HelveticaNeue-Medium", size: 120.0)!))

        static let laterMinutesStyle = baseMinutesStyle.byAdding(
            .font(UIFont(name: "HelveticaNeue", size: 120.0)!))

        static let minutesSubtitleStyle = StringStyle(
            .font(UIFont(name: "HelveticaNeue-Medium", size: 28.0)!))

        static let lineStyle = StringStyle(
            .font(UIFont(name: "HelveticaNeue-Medium", size: 44.0)!),
            .tracking(.point(-0.9)))

        static let destinationPrefixStyle = StringStyle(
            .font(UIFont(name: "HelveticaNeue-Medium", size: 13.5)!))

        static let destinationStyle = StringStyle(
            .font(UIFont(name: "HelveticaNeue-Bold", size: 13.5)!))

    }

    enum Weather {

        static let currentTempStyle = StringStyle(
            .numberSpacing(.proportional),
            .font(.systemFont(ofSize: 120, weight: .heavy)),
            .color(.white),
            .stylisticAlternates(.six(on: true)))

        static let tempRangeStyle = StringStyle(
            .numberSpacing(.proportional),
            .font(.systemFont(ofSize: 48, weight: .heavy)),
            .color(.white),
            .stylisticAlternates(.six(on: true)))

        private static let baseForecastStyle = StringStyle(
            .numberSpacing(.proportional),
            .alignment(.center),
            .color(UIColor(resource: .white)),
            .stylisticAlternates(.six(on: true)))

        static let timeStyle = baseForecastStyle.byAdding(
            .font(.systemFont(ofSize: 20, weight: .semibold)))

        static let precipProbabilityStyle = baseForecastStyle.byAdding(
            .font(.systemFont(ofSize: 16, weight: .semibold)))

        static let tempForecastStyle = baseForecastStyle.byAdding(
            .font(.systemFont(ofSize: 32, weight: .semibold)))

    }

}
