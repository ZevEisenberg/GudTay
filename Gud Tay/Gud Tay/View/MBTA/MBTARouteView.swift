//
//  MBTARouteView.swift
//  Gud Tay
//
//  Created by Zev Eisenberg on 7/26/16.
//  Copyright © 2016 Zev Eisenberg. All rights reserved.
//

import UIKit
import Anchorage
import BonMot

final class MBTARouteView: GridView {

    // Private Properties

    fileprivate let nextTripView = TripView(color: Colors.black, subtitle: "Mins Next", minutesStyle: Fonts.MBTA.nextMinutesStyle)
    fileprivate let laterTripView = TripView(color: Colors.darkGray, subtitle: "Mins Later", minutesStyle: Fonts.MBTA.laterMinutesStyle)

    init(headerView: MBTAHeaderView) {
        super.init(frame: .zero)

        addSubview(headerView)
        headerView.topAnchor == topAnchor
        headerView.horizontalAnchors == horizontalAnchors

        let stackView = UIStackView(arrangedSubviews: [nextTripView, laterTripView])
        stackView.axis = .horizontal
        stackView.spacing = 58.0

        addSubview(stackView)
        stackView.centerXAnchor == centerXAnchor
        stackView.bottomAnchor == bottomAnchor - 19.0
    }

    func setUpcomingTrips(upcomingTrips: MBTAViewModel.UpcomingTrips) {
        updateUI(upcomingTrips: upcomingTrips)
    }

}

private extension MBTARouteView {

    final class TripView: UIView {

        // Public Properties

        func updateMinutesString(_ string: String) {
            minutesLabel.styledText = string
        }

        // Private Properties

        private let minutesLabel = UILabel()

        init(color: UIColor, subtitle: String, minutesStyle: StringStyle) {
            super.init(frame: .zero)
            minutesLabel.accessibilityIdentifier = "minutesLabel - \(subtitle)"
            minutesLabel.bonMotStyle = minutesStyle.byAdding(.color(color))
            minutesLabel.setContentHuggingPriority(.required, for: .vertical)

            let subtitleLabel = UILabel(axId: "subtitleLabel - \(subtitle)")
            subtitleLabel.attributedText = subtitle.styled(with: Fonts.MBTA.minutesSubtitleStyle.byAdding(.color(color)))

            let stackView = UIStackView(arrangedSubviews: [minutesLabel, subtitleLabel])
            stackView.axis = .vertical
            stackView.alignment = .center
            stackView.spacing = -18.0

            addSubview(stackView)
            stackView.edgeAnchors == edgeAnchors
        }

        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

    }

    func updateUI(upcomingTrips: MBTAViewModel.UpcomingTrips) {
        let (next, later) = upcomingTrips.strings

        nextTripView.updateMinutesString(next)
        laterTripView.updateMinutesString(later)
    }

}
