//
//  ContentViewController.swift
//  GudTay
//
//  Created by ZevEisenberg on 3/20/17.
//  Copyright © 2017 ZevEisenberg. All rights reserved.
//

import Anchorage
import Then
import UIKit

class ContentViewController: UIViewController {

    let mbtaContainer = UIView(axId: "mbtaContainer")
    let doodleContainer = UIView(axId: "doodleContainer")
    let calvinContainer = UIView(axId: "calvinContainer")
    let weatherContainer = UIView(axId: "weatherContainer")

    lazy var offlineView = OfflineView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        let mainStackView = UIStackView(axId: "mainStackView").then {
            $0.axis = .vertical
            $0.alignment = .fill
        }
        view.addSubview(mainStackView)
        mainStackView.addArrangedSubview(mbtaContainer)
        mainStackView.addArrangedSubview(doodleContainer)
        mainStackView.addArrangedSubview(calvinContainer)
        mainStackView.addArrangedSubview(weatherContainer)

        mbtaContainer.heightAnchor == doodleContainer.heightAnchor
        doodleContainer.heightAnchor == calvinContainer.heightAnchor

        mainStackView.horizontalAnchors == view.horizontalAnchors
        mainStackView.verticalAnchors == view.safeAreaLayoutGuide.verticalAnchors
        weatherContainer.heightAnchor == 205
    }

    func setOfflineViewVisible(_ visible: Bool) {
        offlineView.removeFromSuperview()
        if visible {
            view.addSubview(offlineView)
            offlineView.edgeAnchors == view.safeAreaLayoutGuide.edgeAnchors
        }
    }

}
