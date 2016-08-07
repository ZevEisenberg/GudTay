//
//  MBTARouteView.swift
//  Gud Tay
//
//  Created by Zev Eisenberg on 7/26/16.
//  Copyright © 2016 Zev Eisenberg. All rights reserved.
//

import UIKit
import Anchorage

final class MBTARouteView: GridView {

    // Public Properties

    var upcomingTrips: MBTAViewModel.UpcomingTrips = .none {
        didSet {
            updateUI()
        }
    }

    // Private Properties

    private var label = UILabel(axId: "label")

    init(headerView: MBTAHeaderView) {
        super.init(frame: .zero)

        addSubview(label)

        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.edgeAnchors == edgeAnchors + 10

        addSubview(headerView)
        headerView.topAnchor == topAnchor
        headerView.horizontalAnchors == horizontalAnchors
    }

}

private extension MBTARouteView {

    func updateUI() {
        switch upcomingTrips {
        case .none:
            label.text = "no upcoming trips"
        case .one(let next):
            label.text = "next mins: \(next.formattedAsMinutes)"
        case .two(let next, let later):
            label.text = "next mins: \(next.formattedAsMinutes)\nlater mins: \(later.formattedAsMinutes)"
        }
    }

}

private extension TimeInterval {

    var formattedAsMinutes: String {
        return String(Int(floor(self / 60.0)))
    }

}
