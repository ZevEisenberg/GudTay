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

    var trips: [Trip] = [] {
        didSet {
            trips.sort { trip1, trip2 in
                return trip1.predictedDeparture < trip2.predictedDeparture
            }
            updateUI()
        }
    }

    // Private Properties

    private var label = UILabel(axId: "label")

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

        guard let firstTrip = trips.first else {
            label.text = "no upcoming trips"
            return
        }

        label.text = "\(firstTrip.name) leaving in \(Int(firstTrip.predictedSecondsAway / 60)) minutes"
    }

}
