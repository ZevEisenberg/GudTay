//
//  MBTACoordinator.swift
//  GudTay
//
//  Created by Zev Eisenberg on 4/17/18.
//

import Anchorage
import Services
import Swiftilities

private let refreshInterval: TimeInterval = 30 // should be 30

final class MBTACoordinator: NSObject, Coordinator {

    typealias Service = MBTAService

    private let service: Service

    private weak var rootViewController: UIViewController?

    init(service: Service) {
        self.service = service
    }

    func start(in rootViewController: UIViewController, subview: UIView) {
        assert(subview.isDescendant(of: rootViewController.view))
        self.rootViewController = rootViewController
        let vc = MBTAViewController()
        rootViewController.addChildViewController(vc)
        subview.addSubview(vc.view)
        vc.view.edgeAnchors == subview.edgeAnchors
        let stop: Identifier<Stop> = "6480" // Hyde Park Ave @ Mt Hope St

        Timer.scheduledTimer(withTimeInterval: refreshInterval, repeats: true, block: { [unowned self] _ in
            _ = self.service.getPredictions(forStop: stop) { result in
                switch result {
                case .success(let predictions):
                    vc.data = (predictions: predictions, date: Date())
                case .failure(let error):
                    Log.error("Error refreshing predictions: \(error)")
                }
            }
        }).fire() // fire once initially

    }

}
