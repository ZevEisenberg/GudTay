//
//  Fonts.swift
//  Gud Tay
//
//  Created by Zev Eisenberg on 8/7/16.
//  Copyright © 2016 Zev Eisenberg. All rights reserved.
//

import BonMot

struct Fonts {

    struct MBTA {

        private static let baseMinutesStyle = StringStyle.style(
            .tracking(.point(-2.68)),
            .numberSpacing(.proportional))

        static let nextMinutesStyle = baseMinutesStyle.byAdding(
            .font(UIFont(name: "HelveticaNeue-Medium", size: 120.0)!))

        static let laterMinutesStyle = baseMinutesStyle.byAdding(
            .font(UIFont(name: "HelveticaNeue", size: 120.0)!))

        static let minutesSubtitleStyle = StringStyle.style(
            .font(UIFont(name: "HelveticaNeue-Medium", size: 28.0)!))

        static let lineStyle = StringStyle.style(
            .font(UIFont(name: "HelveticaNeue-Medium", size: 44.0)!),
            .tracking(.point(-0.9)))

        static let destinationPrefixStyle = StringStyle.style(
            .font(UIFont(name: "HelveticaNeue-Medium", size: 13.5)!))

        static let destinationStyle = StringStyle.style(
            .font(UIFont(name: "HelveticaNeue-Bold", size: 13.5)!))

    }

    struct Weather {

        static let currentTempStyle = StringStyle.style(
            .numberSpacing(.proportional),
            .font(UIFont(name: "HelveticaNeue-Bold", size: 120.0)!))

        static let tempRangeStyle = StringStyle.style(
            .numberSpacing(.proportional),
            .font(UIFont(name: "HelveticaNeue-Bold", size: 48.0)!))

        private static let baseForecastStyle = StringStyle.style(
            .numberSpacing(.proportional),
            .alignment(.center),
            .color(Colors.white))

        static let timeStyle = baseForecastStyle.byAdding(
            .font(UIFont(name: "HelveticaNeue-Medium", size: 20.0)!))

        static let precipProbabilityStyle = baseForecastStyle.byAdding(
            .font(UIFont(name: "HelveticaNeue-Medium", size: 16.0)!))

        static let tempForecastStyle = baseForecastStyle.byAdding(
            .font(UIFont(name: "HelveticaNeue-Medium", size: 32.0)!))

    }

}
