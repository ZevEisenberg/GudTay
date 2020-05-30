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
            .font(UIFont(name: "HelveticaNeue-Bold", size: 120.0)!),
            .color(.white))

        static let tempRangeStyle = StringStyle(
            .numberSpacing(.proportional),
            .font(UIFont(name: "HelveticaNeue-Bold", size: 48.0)!),
            .color(.white))

        private static let baseForecastStyle = StringStyle(
            .numberSpacing(.proportional),
            .alignment(.center),
            .color(Asset.white.color))

        static let timeStyle = baseForecastStyle.byAdding(
            .font(UIFont(name: "HelveticaNeue-Medium", size: 20.0)!))

        static let precipProbabilityStyle = baseForecastStyle.byAdding(
            .font(UIFont(name: "HelveticaNeue-Medium", size: 16.0)!))

        static let tempForecastStyle = baseForecastStyle.byAdding(
            .font(UIFont(name: "HelveticaNeue-Medium", size: 32.0)!))

    }

}
