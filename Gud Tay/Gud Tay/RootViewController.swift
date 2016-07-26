//
//  RootViewController.swift
//  Gud Tay
//
//  Created by Zev Eisenberg on 7/24/16.
//  Copyright © 2016 Zev Eisenberg. All rights reserved.
//

import UIKit
import Anchorage

class RootViewController: UIViewController {

    @IBOutlet var subwayOrangeLine: UIView!
    @IBOutlet var busCT2: UIView!
    @IBOutlet var bus86: UIView!
    @IBOutlet var bus90: UIView!
    @IBOutlet var bus91: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let mappings = [
            (containerView: subwayOrangeLine, routeType: ModeType.subway, routeId: "Orange", directionId: "0"),
            (containerView: busCT2, routeType: ModeType.bus, routeId: "747", directionId: "0"),
            (containerView: bus86, routeType: ModeType.bus, routeId: "86", directionId: "1"),
            (containerView: bus90, routeType: ModeType.bus, routeId: "90", directionId: "1"),
            (containerView: bus91, routeType: ModeType.bus, routeId: "91", directionId: "1"),
        ]

        for mapping in mappings {
            let mbtaVC = MBTAViewController()
            addChildViewController(mbtaVC)
            mapping.containerView.addSubview(mbtaVC.view)
            mbtaVC.view.edgeAnchors == mapping.containerView.edgeAnchors
            mbtaVC.didMove(toParentViewController: self)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        APIClient.predictionsByStop(stopId: "place-sull") { result in
            switch result {
            case .success(let jsonObject):
                guard let jsons = jsonObject else {
                    self.errorAlert(message: "nil json object")
                    return
                }

                do {
                    let sullivan = try Stop(json: jsons)
                    self.processStop(sullivan)
                } catch let e {
                    self.errorAlert(message: String(e))
                }

            case .failure(let error):
                self.errorAlert(message: error.localizedDescription)
            }
        }
    }

}

private extension RootViewController {

    func errorAlert(message: String) {
        show(UIAlertController(title: "Error", message: message, preferredStyle: .alert), sender: self)
    }

    func processStop(_ stop: Stop) {
        for mode in stop.modes {
            for route in mode.routes {
                print(route.name)
                for direction in route.directions {
                    print(direction.name)
                    for trip in direction.trips {
                        print(trip.name)
                    }
                }
            }
        }
    }

}
