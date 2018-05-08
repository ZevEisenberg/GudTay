//
//  MBTAViewController.swift
//  GudTay
//
//  Created by Zev Eisenberg on 4/17/18.
//

import Anchorage
import Services
import Then
import UIKit

class MBTAViewController: UIViewController {

    let busHeader = MBTARouteView(headerView: BusHeaderView(route: "32", destination: "Forest Hills")).then {
        $0.borderedEdges = [.bottom]
    }

    var data: (predictions: [Prediction], date: Date) = ([], Date()) {
        didSet {
            let predictionsOfInterest = data.predictions
                .filter { $0.route.id == APIConstants.routeOfInterest }
                .filter { $0.directionId == $0.route.directionNames.index(of: "Inbound")! }
                .filter { $0.departureTime > data.date }
                .sorted { $0.departureTime < $1.departureTime }
                .prefix(2)
            busHeader.setUpcomingTrips(upcomingTrips: MBTARouteView.UpcomingTrips(predictions: Array(predictionsOfInterest)), relativeToDate: data.date)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(busHeader)
        busHeader.edgeAnchors == edgeAnchors
    }

}
