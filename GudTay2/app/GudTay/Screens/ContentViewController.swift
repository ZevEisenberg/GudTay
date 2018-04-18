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
    let whiteboardContainer = UIView(axId: "whiteboardContainer")
    let calvinContainer = UIView(axId: "calvinContainer")
    let weatherContainer = UIView(axId: "weatherContainer")

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {

        // MBTA

        // Weather

        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

    }

    @available(*, unavailable) required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        let mainStackView = UIStackView(axId: "mainStackView").then {
            $0.axis = .vertical
            $0.alignment = .fill
            $0.distribution = .fillEqually
        }
        view.addSubview(mainStackView)
        mainStackView.addArrangedSubview(mbtaContainer)
        mainStackView.addArrangedSubview(whiteboardContainer)
        mainStackView.addArrangedSubview(calvinContainer)
        mainStackView.addArrangedSubview(weatherContainer)
        mainStackView.horizontalAnchors == view.horizontalAnchors
        mainStackView.verticalAnchors == view.safeAreaLayoutGuide.verticalAnchors

        weatherContainer.backgroundColor = Color.day.color
    }

}
