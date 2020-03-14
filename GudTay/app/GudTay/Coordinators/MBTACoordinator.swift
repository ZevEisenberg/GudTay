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
private let stop: Identifier<Stop> = "6480" // Hyde Park Ave @ Mt Hope St

final class MBTACoordinator: NSObject, Coordinator {

    typealias Service = MBTAService

    private let service: Service

    private weak var rootViewController: UIViewController?
    private weak var mbtaViewController: MBTAViewController?

    init(service: Service) {
        self.service = service
    }

    func start(in rootViewController: UIViewController, subview: UIView) {
        assert(subview.isDescendant(of: rootViewController.view))
        self.rootViewController = rootViewController
        let vc = MBTAViewController()
        mbtaViewController = vc
        rootViewController.addChild(vc)
        subview.addSubview(vc.view)
        vc.view.edgeAnchors == subview.edgeAnchors

        Timer.scheduledTimer(withTimeInterval: refreshInterval, repeats: true, block: { [weak self] _ in
            self?.refresh()
        }).fire() // fire once initially
    }

    func refresh() {
        _ = self.service.getPredictions(forStop: stop) { result in
            switch result {
            case .success(let predictions):
                self.mbtaViewController?.data = (predictions: predictions, date: Date())
            case .failure(let error):
                Log.error("Error refreshing predictions: \(error)")
            }
        }
    }

}
