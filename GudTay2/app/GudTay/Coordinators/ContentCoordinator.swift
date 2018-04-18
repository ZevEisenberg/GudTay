//
//  ContentCoordinator.swift
//  GudTay
//
//  Created by ZevEisenberg on 3/27/17.
//  Copyright © 2017 ZevEisenberg. All rights reserved.
//

import Anchorage
import Services
import UIKit

class ContentCoordinator: NSObject, Coordinator {

    let mbtaService: MBTAService

    let baseController: UIViewController
    var childCoordinator: Coordinator?
    var contentViewController: ContentViewController?

    var mbtaCoordinator: MBTACoordinator?

    init(_ baseController: UIViewController, mbtaService: MBTAService) {
        self.baseController = baseController
        self.mbtaService = mbtaService
    }

    func start(completion: (() -> Void)?) {
        let contentViewController = ContentViewController()
        self.contentViewController = contentViewController
        contentViewController.modalTransitionStyle = .crossDissolve
        baseController.present(contentViewController, animated: false, completion: {
            self.mbtaCoordinator = MBTACoordinator(service: self.mbtaService)
            self.mbtaCoordinator?.start(in: contentViewController, subview: contentViewController.mbtaContainer)

            let doodleView = DoodleView()
            contentViewController.doodleContainer.addSubview(doodleView)
            doodleView.edgeAnchors == contentViewController.doodleContainer.edgeAnchors
            doodleView.borderedEdges = [.bottom]
            doodleView.delegate = self
            completion?()
        })
    }

    func cleanup(animated: Bool, completion: (() -> Void)?) {
        baseController.dismiss(animated: animated, completion: completion)
    }

}

extension ContentCoordinator: DoodleView.Delegate {

    func doodleView(_ view: DoodleView, didNotify action: DoodleView.Action) {
        switch action {
        case .showClearPrompt(let sourceButton, let completion):
            // verbs via http://calvinandhobbes.wikia.com/wiki/Spaceman_Spiff#Spiff.27s_Weaponry_and_Equipment
            let verbs = ["Shake-n’-Bake", "Medium Well", "Deep Fat-fry", "Frappe", "Liquefy"]
            guard let verb = verbs.random else {
                preconditionFailure("Accessing random element from collection literal should never be nil")
            }

            let alert = UIAlertController(title: "Zap drawing at \(verb) setting?", message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
                completion(false)
            }))

            alert.addAction(UIAlertAction(title: "\(verb.localizedUppercase)!", style: .destructive, handler: { _ in
                completion(true)
            }))

            contentViewController?.show(alert, sender: self)
            alert.popoverPresentationController?.sourceView = sourceButton
            alert.popoverPresentationController?.sourceRect = sourceButton.bounds
        }
    }

}
