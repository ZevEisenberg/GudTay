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

    private let openWeatherService: OpenWeatherService

    private weak var rootViewController: UIViewController?
    private weak var weatherViewController: WeatherViewController?

    init(openWeatherService: OpenWeatherService) {
        self.openWeatherService = openWeatherService
    }

    func start(in rootViewController: UIViewController, subview: UIView) {
        assert(subview.isDescendant(of: rootViewController.view))
        self.rootViewController = rootViewController
        let vm = WeatherViewModel(openWeatherService: openWeatherService)
        let vc = WeatherViewController(viewModel: vm, refreshInterval: refreshInterval)
        weatherViewController = vc
        rootViewController.addChild(vc)
        subview.addSubview(vc.view)
        vc.view.edgeAnchors == subview.edgeAnchors
    }

    func refresh() {
        weatherViewController?.refresh()
    }

}
