//
//  WeatherCoordinator.swift
//  GudTay
//
//  Created by Zev Eisenberg on 4/18/18.
//

import Anchorage
import Services
import Swiftilities

private let refreshInterval: TimeInterval = 10 * 60 // should be 10 minutes

final class WeatherCoordinator: NSObject, Coordinator {

    typealias Service = WeatherServiceProtocol

    private let service: Service

    private weak var rootViewController: UIViewController?

    init(service: Service) {
        self.service = service
    }

    func start(in rootViewController: UIViewController, subview: UIView) {
        assert(subview.isDescendant(of: rootViewController.view))
        self.rootViewController = rootViewController
        let vm = WeatherViewModel(service: service)
        let vc = WeatherViewController(viewModel: vm, refreshInterval: refreshInterval)
        rootViewController.addChildViewController(vc)
        subview.addSubview(vc.view)
        vc.view.edgeAnchors == subview.edgeAnchors
    }

}
