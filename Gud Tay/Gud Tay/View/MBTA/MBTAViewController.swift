//
//  MBTAViewController.swift
//  Gud Tay
//
//  Created by Zev Eisenberg on 7/25/16.
//  Copyright © 2016 Zev Eisenberg. All rights reserved.
//

import UIKit
import Anchorage

final class MBTAViewController: RefreshableViewController {

    // Private Properties

    private let viewModel: MBTAViewModel

    private let bus32 = MBTARouteView(headerView:
        BusHeaderView(route: "32", destination: "Forest Hills"))
    private let doodle = DoodleView()

    private let mainStackView: UIStackView = {
        let stackView = UIStackView(axId: "mainStackView")
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        return stackView
    }()

    private let rowStackViews: [UIStackView] = (0..<3).map { row in
        let stackView = UIStackView(axId: "stack view \(row)")
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }

    init(viewModel: MBTAViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)

        doodle.delegate = self
    }

    override func loadView() {
        view = UIView(axId: "MBTAViewController.view")

        view.addSubview(mainStackView)
        rowStackViews.forEach {
            mainStackView.addArrangedSubview($0)
        }

        let gudTayView = GudTayView(tapHandler: { [weak self] in
            let logVC = LogViewController()
            let navCon = UINavigationController(rootViewController: logVC)
            navCon.modalPresentationStyle = .formSheet
            self?.show(navCon, sender: self)
        })

        rowStackViews[0].addArrangedSubview(bus32)
        rowStackViews[1].addArrangedSubview(doodle)
        rowStackViews[2].addArrangedSubview(gudTayView)

        bus32.borderedEdges = [.bottom]
        doodle.borderedEdges = [.bottom]
        gudTayView.borderedEdges = [.bottom]
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        mainStackView.edgeAnchors == view.edgeAnchors
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let routeViews = [
            bus32,
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

// MARK: - DoodleViewDelegate

extension MBTAViewController: DoodleViewDelegate {

    func showClearPrompt(from button: UIButton, completion: @escaping (_ clear: Bool) -> Void) {
        // verbs via http://calvinandhobbes.wikia.com/wiki/Spaceman_Spiff#Spiff.27s_Weaponry_and_Equipment
        let verbs = ["Shake-n’-Bake", "Medium Well", "Deep Fat-fry", "Frappe", "Liquefy"]
        guard let verb = verbs.random else {
            preconditionFailure("Accessing random element from collection literal should never be nil")
        }

        let alert = UIAlertController(title: "Zap drawing at \(verb) setting?", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            completion(false)
        }))

        alert.addAction(UIAlertAction(title: "\(verb.localizedUppercase)!", style: .destructive, handler: { _ in
            completion(true)
        }))

        show(alert, sender: self)
        alert.popoverPresentationController?.sourceView = button
        alert.popoverPresentationController?.sourceRect = button.bounds
    }

}

// MARK: - Private

private extension MBTAViewController {

    func processTrips(_ trips: [MBTAViewModel.UpcomingTrips], routeViews: [MBTARouteView]) {
        zip(routeViews, trips).forEach { routeView, trips in
            routeView.setUpcomingTrips(upcomingTrips: trips)
        }
    }

}
