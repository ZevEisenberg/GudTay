//
//  ContentCoordinator.swift
//  GudTay
//
//  Created by ZevEisenberg on 3/27/17.
//  Copyright © 2017 ZevEisenberg. All rights reserved.
//

import Anchorage
import Reachability
import Services
import UIKit

class ContentCoordinator: NSObject, Coordinator {

    let mbtaService: MBTAService
    let weatherService: WeatherServiceProtocol
    let openWeatherService: OpenWeatherService

    let baseController: UIViewController
    var childCoordinator: Coordinator?
    var contentViewController: ContentViewController?
    var doodleViewController: DoodleViewController?

    var mbtaCoordinator: MBTACoordinator?
    var weatherCoordinator: WeatherCoordinator?

    private let reachability = try! Reachability() // swiftlint:disable:this force_try

    init(_ baseController: UIViewController, mbtaService: MBTAService, weatherService: WeatherServiceProtocol, openWeatherService: OpenWeatherService) {
        self.baseController = baseController
        self.mbtaService = mbtaService
        self.weatherService = weatherService
        self.openWeatherService = openWeatherService
    }

    func start(completion: (() -> Void)?) {
        let contentViewController = ContentViewController()
        self.contentViewController = contentViewController
        contentViewController.modalTransitionStyle = .crossDissolve
        baseController.present(contentViewController, animated: false, completion: {
            self.mbtaCoordinator = MBTACoordinator(service: self.mbtaService)
            self.mbtaCoordinator?.start(in: contentViewController, subview: contentViewController.mbtaContainer)

            let doodleViewController = DoodleViewController()
            self.doodleViewController = doodleViewController

            contentViewController.addChild(doodleViewController)
            contentViewController.doodleContainer.addSubview(doodleViewController.view)
            doodleViewController.didMove(toParent: contentViewController)
            doodleViewController.doodleView.edgeAnchors == contentViewController.doodleContainer.edgeAnchors
            doodleViewController.doodleView.borderedEdges = [.bottom]

            let gudTayView = GudTayView(tapHandler: { [weak self] in
                let logVC = LogViewController()
                let navCon = UINavigationController(rootViewController: logVC)
                navCon.modalPresentationStyle = .formSheet
                self?.contentViewController?.show(navCon, sender: self)
            })
            contentViewController.calvinContainer.addSubview(gudTayView)
            gudTayView.edgeAnchors == contentViewController.calvinContainer.edgeAnchors
            gudTayView.borderedEdges = [.bottom]

            self.weatherCoordinator = WeatherCoordinator(service: self.weatherService)
            self.weatherCoordinator?.start(in: contentViewController, subview: contentViewController.weatherContainer)

            self.reachability.whenUnreachable = { [weak self] _ in
                self?.contentViewController?.setOfflineViewVisible(true)
            }

            self.reachability.whenReachable = { [weak self] _ in
                self?.contentViewController?.setOfflineViewVisible(false)
                self?.mbtaCoordinator?.refresh()
                self?.weatherCoordinator?.refresh()
            }

            do {
                try self.reachability.startNotifier()
            }
            catch {
                LogService.add(message: "Error starting Reachability: \(error)")
                assertionFailure("Error starting Reachability: \(error)")
            }

            completion?()
        })
    }

    func cleanup(animated: Bool, completion: (() -> Void)?) {
        baseController.dismiss(animated: animated, completion: completion)
    }

}
