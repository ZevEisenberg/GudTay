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

    let mbtaService: MBTAService

    let baseController: UIViewController
    var childCoordinator: Coordinator?

    var mbtaCoordinator: MBTACoordinator?

    init(_ baseController: UIViewController, mbtaService: MBTAService) {
        self.baseController = baseController
        self.mbtaService = mbtaService
    }

    func start(animated: Bool, completion: (() -> Void)?) {
        let vc = ContentViewController()
        vc.modalTransitionStyle = .crossDissolve
        baseController.present(vc, animated: animated, completion: {
            self.mbtaCoordinator = MBTACoordinator(service: self.mbtaService)
            self.mbtaCoordinator?.start(in: vc, subview: vc.mbtaContainer)
            completion?()
        })
    }

    func cleanup(animated: Bool, completion: (() -> Void)?) {
        baseController.dismiss(animated: animated, completion: completion)
    }

}
