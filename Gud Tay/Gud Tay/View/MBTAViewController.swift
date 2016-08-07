//
//  MBTAViewController.swift
//  Gud Tay
//
//  Created by Zev Eisenberg on 7/25/16.
//  Copyright © 2016 Zev Eisenberg. All rights reserved.
//

import UIKit
import Anchorage

class MBTAViewController: UIViewController {

    let viewModel: MBTAViewModel

    let subwayOrangeLine = MBTARouteView(headerView:
        SubwayHeaderView(route: "Orange Line", direction: "Inbound", destination: "Forest Hills"))
    let busCT2 = MBTARouteView(headerView:
        BusHeaderView(route: "CT2", destination: "Ruggles"))
    let bus86 = MBTARouteView(headerView:
        BusHeaderView(route: "86", destination: "Reservoir"))
    let bus90 = MBTARouteView(headerView:
        BusHeaderView(route: "90", destination: "Davis"))
    let bus91 = MBTARouteView(headerView:
        BusHeaderView(route: "91", destination: "Central"))

    let mainStackView: UIStackView = {
        let stackView = UIStackView(axId: "mainStackView")
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        return stackView
    }()

    let rowStackViews: [UIStackView] = (0..<3).map { row in
        let stackView = UIStackView(axId: "stack view \(row)")
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }

    init(viewModel: MBTAViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable) required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = UIView(axId: "MBTAViewController.view")

        view.addSubview(mainStackView)
        rowStackViews.forEach {
            mainStackView.addArrangedSubview($0)
        }

        rowStackViews[0].addArrangedSubview(subwayOrangeLine)
        rowStackViews[0].addArrangedSubview(busCT2)
        rowStackViews[1].addArrangedSubview(bus86)
        rowStackViews[1].addArrangedSubview(bus90)
        rowStackViews[2].addArrangedSubview(bus91)
        rowStackViews[2].addArrangedSubview(GudTayView(axId: "gudTayView"))
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        mainStackView.edgeAnchors == view.edgeAnchors
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let routeViews = [
            subwayOrangeLine,
            busCT2,
            bus86,
            bus90,
            bus91,
        ]

        Timer.scheduledTimer(withTimeInterval: 30.0, repeats: true, block: { _ in
            self.viewModel.refresh() { result in
                switch result {
                case .success(let trips):
                    self.processTrips(trips, routeViews: routeViews)
                case .failure(let error):
                    self.processRefreshError(error)
                }
            }
        }).fire() // fire once initially
    }

}

private extension MBTAViewController {

    func errorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        show(alert, sender: self)
    }

    func processTrips(_ trips: [MBTAViewModel.UpcomingTrips], routeViews: [MBTARouteView]) {
        zip(routeViews, trips).forEach { routeView, trips in
            routeView.upcomingTrips = trips
        }
    }

    func processRefreshError(_ error: MBTAViewModel.RefreshError) {
        switch error {
        case .jsonWasNil:
            errorAlert(message: "Error: JSON from server was nil")
        case .networkError(let nsError):
            errorAlert(message: "Network error: \(nsError.localizedDescription)")
        case .jsonError(let jsonError):
            errorAlert(message: "JSON Error: \(jsonError)")
        case .genericError(let genericError):
            errorAlert(message: "Generic error: \(genericError)")
        }
    }

}
