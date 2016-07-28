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

    let subwayOrangeLine = MBTARouteView(axId: "subwayOrangeLine")
    let busCT2 = MBTARouteView(axId: "busCT2")
    let bus86 = MBTARouteView(axId: "bus86")
    let bus90 = MBTARouteView(axId: "bus90")
    let bus91 = MBTARouteView(axId: "bus91")

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

        Timer.scheduledTimer(withTimeInterval: 30.0, repeats: true, block: { _ in
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
                    } catch JSONError.generic {
                        BuddyBuildSDK.setCrashMetadataObject("Generic JSON Error", forKey: "deserializationError")
                        fatalError("Generic JSON Error")
                    } catch JSONError.malformedOrMissingKey(let key) {
                        BuddyBuildSDK.setCrashMetadataObject("malformed or missing key: \(key)", forKey: "deserializationError")
                        fatalError("malformed or missing key: \(key)")
                    } catch JSONError.malformedValue(let key, let value) {
                        BuddyBuildSDK.setCrashMetadataObject("malformed value '\(value)' for key '\(key)'", forKey: "deserializationError")
                        fatalError("malformed value '\(value)' for key '\(key)'")
                    } catch JSONError.malformedDescendent(let descendent) {
                        BuddyBuildSDK.setCrashMetadataObject("malformed descendent: \(descendent)", forKey: "deserializationError")
                        fatalError("malformed descendent: \(descendent)")
                    } catch let e {
                        BuddyBuildSDK.setCrashMetadataObject("Other error: \(e)", forKey: "deserializationError")
                        self.errorAlert(message: String(e))
                    }

                case .failure(let error):
                    self.errorAlert(message: error.localizedDescription)
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

    func processStop(_ stop: Stop) {

        let mappings = [
            (containerView: subwayOrangeLine, routeType: ModeType.subway, routeId: "Orange", directionId: "0"),
            (containerView: busCT2, routeType: ModeType.bus, routeId: "747", directionId: "0"),
            (containerView: bus86, routeType: ModeType.bus, routeId: "86", directionId: "1"),
            (containerView: bus90, routeType: ModeType.bus, routeId: "90", directionId: "1"),
            (containerView: bus91, routeType: ModeType.bus, routeId: "91", directionId: "1"),
            ]

        for (containerView, routeType, routeId, directionId) in mappings {
            let trips = stop.modes
                .filter { mode in mode.type == routeType }
                .flatMap { mode in mode.routes }
                .filter { route in route.identifier == routeId }
                .flatMap { route in route.directions }
                .filter { direction in direction.identifier == directionId }
                .flatMap { direction in direction.trips }
            containerView.trips = trips
        }

    }

}
