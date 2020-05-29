//
//  AppCoordinator.swift
//  GudTay
//
//  Created by ZevEisenberg on 3/24/17.
//  Copyright © 2017 ZevEisenberg. All rights reserved.
//

import Services
import UIKit

class AppCoordinator: NSObject, Coordinator {

    private let window: UIWindow
    private let mbtaService: MBTAService
    private let openWeatherService: OpenWeatherService

    private let rootController: UIViewController
    var childCoordinator: Coordinator?

    init(window: UIWindow, mbtaService: MBTAService, openWeatherService: OpenWeatherService) {
        self.window = window
        self.mbtaService = mbtaService
        self.openWeatherService = openWeatherService
        let rootController = UIViewController()
        rootController.view.backgroundColor = .white
        self.rootController = rootController
    }

    func start(completion: (() -> Void)?) {
        // Configure window/root view
        let contentCoordinator = ContentCoordinator(rootController, mbtaService: mbtaService, openWeatherService: openWeatherService)
        self.childCoordinator = contentCoordinator
        window.rootViewController = rootController
        window.makeKeyAndVisible()
        DispatchQueue.main.async { // avoid unbalanced calls to begin/end appearance transitions
            contentCoordinator.start(completion: nil)
        }
    }

    func cleanup(animated: Bool, completion: (() -> Void)?) {
        completion?()
    }

}
