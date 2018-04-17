//
//  MBTACoordinator.swift
//  GudTay
//
//  Created by Zev Eisenberg on 4/17/18.
//

import Services

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
        let stop: Identifier<Stop> = "6480" // Hyde Park Ave @ Mt Hope St
        _ = service.getPredictions(forStop: stop) { result in
            print(result)
        }
    }

}
