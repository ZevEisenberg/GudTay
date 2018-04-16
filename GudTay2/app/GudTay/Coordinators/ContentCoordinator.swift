//
//  ContentCoordinator.swift
//  GudTay
//
//  Created by ZevEisenberg on 3/27/17.
//  Copyright © 2017 ZevEisenberg. All rights reserved.
//

import Services
import UIKit

class ContentCoordinator: NSObject, Coordinator {

    let baseController: UIViewController
    var childCoordinator: Coordinator?

    init(_ baseController: UIViewController) {
        self.baseController = baseController
    }

    func start(animated: Bool, completion: VoidClosure?) {
        let vc = ContentViewController()
        vc.modalTransitionStyle = .crossDissolve
        baseController.present(vc, animated: animated, completion: completion)
    }

    func cleanup(animated: Bool, completion: VoidClosure?) {
        baseController.dismiss(animated: animated, completion: completion)
    }

}
