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

    fileprivate let rootController: UIViewController
    var childCoordinator: Coordinator?

    init(window: UIWindow, mbtaService: MBTAService) {
        self.window = window
        self.mbtaService = mbtaService
        let rootController = UIViewController()
        rootController.view.backgroundColor = .white
        self.rootController = rootController
    }

    func start(completion: (() -> Void)?) {
        // Configure window/root view
        let contentCoordinator = ContentCoordinator(rootController, mbtaService: mbtaService)
        self.childCoordinator = contentCoordinator
        window.rootViewController = rootController
        window.makeKeyAndVisible()
        contentCoordinator.start(completion: nil)
    }

    func cleanup(animated: Bool, completion: (() -> Void)?) {
        completion?()
    }

}
