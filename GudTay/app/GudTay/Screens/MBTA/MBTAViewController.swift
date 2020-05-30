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
            // Using type annotations to speed up compilation
            typealias PredictionAndDate = (prediction: Prediction, departureTime: Date)
            let predictionsOfInterest = data.predictions
                .filter { (p: Prediction) -> Bool in p.route?.id == APIConstants.routeOfInterest }
                .filter { (p: Prediction) -> Bool in p.directionId == p.route?.directionNames.firstIndex(of: "Inbound") }
                .compactMap { (p: Prediction) -> PredictionAndDate? in p.departureTime.map { time in (prediction: p, departureTime: time) } }
                .filter { (tuple: PredictionAndDate) -> Bool in tuple.departureTime > data.date }
                .sorted(by: \.departureTime)
                .prefix(3)
                .map { (tuple: PredictionAndDate) in tuple.prediction }
            busHeader.setUpcomingTrips(upcomingTrips: MBTARouteView.UpcomingTrips(predictions: Array(predictionsOfInterest)), relativeToDate: data.date)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(busHeader)
        busHeader.edgeAnchors == edgeAnchors
    }

}
