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

    let baseController: UIViewController
    var childCoordinator: Coordinator?
    var contentViewController: ContentViewController?
    var doodleViewController: DoodleViewController?

    var mbtaCoordinator: MBTACoordinator?
    var weatherCoordinator: WeatherCoordinator?

    private let reachability = try! Reachability() // swiftlint:disable:this force_try

    init(_ baseController: UIViewController, mbtaService: MBTAService) {
        self.baseController = baseController
        self.mbtaService = mbtaService
    }

    func start(completion: (() -> Void)?) {
        let contentViewController = ContentViewController()
        self.contentViewController = contentViewController
        contentViewController.modalPresentationStyle = .fullScreen
        contentViewController.modalTransitionStyle = .crossDissolve
        baseController.present(contentViewController, animated: false, completion: {
            self.secondPartOfStart(contentViewController: contentViewController, completion: completion)
        })
    }

    // Separate function to improve compile times
    private func secondPartOfStart(contentViewController: ContentViewController, completion: (() -> Void)?) {
        mbtaCoordinator = MBTACoordinator(service: mbtaService)
        mbtaCoordinator?.start(in: contentViewController, subview: contentViewController.mbtaContainer)

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

        weatherCoordinator = WeatherCoordinator()
        weatherCoordinator?.start(in: contentViewController, subview: contentViewController.weatherContainer)

        reachability.whenUnreachable = { [weak self] _ in
            self?.contentViewController?.setOfflineViewVisible(true)
        }

        reachability.whenReachable = { [weak self] _ in
            guard let self = self else { return }
            self.contentViewController?.setOfflineViewVisible(false)
            self.mbtaCoordinator?.refresh()
            self.weatherCoordinator?.refresh()
        }

        do {
            try reachability.startNotifier()
        }
        catch {
            LogService.add(message: "Error starting Reachability: \(error)")
            assertionFailure("Error starting Reachability: \(error)")
        }

        completion?()
    }

    func cleanup(animated: Bool, completion: (() -> Void)?) {
        baseController.dismiss(animated: animated, completion: completion)
    }

}
