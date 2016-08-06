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

    var header: MBTAViewModel.Header? {
        didSet {
            updateUI()
        }
    }

    // Private Properties

    private var label = UILabel(axId: "label")

    private var headerView: MBTAHeaderView? {
        willSet {
            headerView?.removeFromSuperview()
        }
        didSet {
            guard let headerView = headerView else { return }
            addSubview(headerView)
            headerView.topAnchor == topAnchor
            headerView.horizontalAnchors == horizontalAnchors
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(label)

        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.edgeAnchors == edgeAnchors + 10
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

        guard let header = header else {
            return
        }

        switch header {
        case .bus(let route, let destination):
            print("setting up bus header view with route \(route), destination \(destination)")
            headerView = BusHeaderView()
        case .subway(let route, let destination):
            print("setting up subway header view with route \(route), destination \(destination)")
            headerView = SubwayHeaderView()
        }
    }

}

private extension TimeInterval {

    var formattedAsMinutes: String {
        return String(Int(floor(self / 60.0)))
    }

}
