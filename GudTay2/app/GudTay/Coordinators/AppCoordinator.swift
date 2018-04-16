//
//  AppCoordinator.swift
//  GudTay
//
//  Created by ZevEisenberg on 3/24/17.
//  Copyright © 2017 ZevEisenberg. All rights reserved.
//

import Services
import UIKit

class AppCoordinator: Coordinator {

    private let window: UIWindow
    fileprivate let rootController: UIViewController
    var childCoordinator: Coordinator?

    init(window: UIWindow) {
        self.window = window
        let rootController = UIViewController()
        rootController.view.backgroundColor = .white
        self.rootController = rootController
    }

    func start(animated: Bool, completion: VoidClosure?) {
        // Configure window/root view
        let contentCoordinator = ContentCoordinator(self.rootController)
        self.childCoordinator = contentCoordinator
        contentCoordinator.start(animated: false, completion: nil)

        window.makeKeyAndVisible()
    }

    func cleanup(animated: Bool, completion: VoidClosure?) {
        completion?()
    }

}
