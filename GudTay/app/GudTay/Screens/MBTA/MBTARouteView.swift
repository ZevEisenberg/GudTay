//
//  MBTARouteView.swift
//  Gud Tay
//
//  Created by Zev Eisenberg on 7/26/16.
//  Copyright © 2016 Zev Eisenberg. All rights reserved.
//

import Anchorage
import BonMot
import Services
import UIKit
import Utilities

final class MBTARouteView: GridView {

    // Private Properties

    private let nextTripView = TripView(color: .GudTay.black, subtitle: "Mins Next", minutesStyle: Fonts.MBTA.nextMinutesStyle)
    private let laterTripView = TripView(color: .darkGray, subtitle: "Mins Later", minutesStyle: Fonts.MBTA.laterMinutesStyle)
    private let afterThatTripView = TripView(color: .GudTay.lightGray, subtitle: "After That", minutesStyle: Fonts.MBTA.laterMinutesStyle)

    init(headerView: MBTAHeaderView) {
        super.init(frame: .zero)

        contentView.addSubview(headerView)
        headerView.topAnchor == topAnchor
        headerView.horizontalAnchors == horizontalAnchors

        let stackView = UIStackView(arrangedSubviews: [nextTripView, laterTripView, afterThatTripView])
        stackView.axis = .horizontal
        stackView.spacing = 58.0

        contentView.addSubview(stackView)
        stackView.centerXAnchor == centerXAnchor
        stackView.bottomAnchor == bottomAnchor - 19.0
    }

    func setUpcomingTrips(upcomingTrips: UpcomingTrips, relativeToDate now: Date) {
        updateUI(forUpcomingTrips: upcomingTrips, relativeToDate: now)
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

        init(color: UIColor, subtitle: String, minutesStyle: BonMot.StringStyle) {
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

    func updateUI(forUpcomingTrips upcomingTrips: UpcomingTrips, relativeToDate now: Date) {
        let oneMinuteFromNow = now.addingTimeInterval(60)
        let (next, later, afterThat) = upcomingTrips.strings(forDate: oneMinuteFromNow)

        nextTripView.updateMinutesString(next)
        laterTripView.updateMinutesString(later)
        afterThatTripView.updateMinutesString(afterThat)
    }

}

private extension TimeInterval {

    var asNonNegativeMinutes: String {
        String(Int(floor(max(self, 0) / 60.0)))
    }

}

extension MBTARouteView {

    enum UpcomingTrips: Equatable {
        case three(next: Date, later: Date, afterThat: Date)
        case two(next: Date, later: Date)
        case one(next: Date)
        case none

        init(predictions: [Prediction]) {
            assert(predictions.count <= 3)

            guard !predictions.isEmpty else {
                self = .none
                return
            }

            guard let first = predictions.first?.departureTime else { self = .none; return }
            guard let second = predictions[checked: 1]?.departureTime else { self = .one(next: first); return }
            guard let third = predictions[checked: 2]?.departureTime else { self = .two(next: first, later: second); return }
            self = .three(next: first, later: second, afterThat: third)
        }

        func strings(forDate now: Date) -> (next: String, later: String, afterThat: String) {
            let noUpcomingTime = "--"
            switch self {
            case .none:
                return (next: noUpcomingTime, later: noUpcomingTime, afterThat: noUpcomingTime)
            case let .one(next):
                let nextSeconds = next.timeIntervalSince(now)
                return (next: nextSeconds.asNonNegativeMinutes, later: noUpcomingTime, afterThat: noUpcomingTime)
            case let .two(next, later):
                let nextSeconds = next.timeIntervalSince(now)
                let laterSeconds = later.timeIntervalSince(now)
                let secondsAfterNextSeconds = laterSeconds - nextSeconds
                return (next: nextSeconds.asNonNegativeMinutes, later: secondsAfterNextSeconds.asNonNegativeMinutes, afterThat: noUpcomingTime)
            case let .three(next, later, afterThat):
                let nextSeconds = next.timeIntervalSince(now)
                let laterSeconds = later.timeIntervalSince(now)
                let afterThatSeconds = afterThat.timeIntervalSince(now)
                let secondsAfterNextSeconds = laterSeconds - nextSeconds
                let secondsAfterThatSeconds = afterThatSeconds - laterSeconds
                return (next: nextSeconds.asNonNegativeMinutes, later: secondsAfterNextSeconds.asNonNegativeMinutes, secondsAfterThatSeconds.asNonNegativeMinutes)
            }
        }

    }

}
