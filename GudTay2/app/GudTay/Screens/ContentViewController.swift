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

    private let mbtaViewController: UIViewController //TODO: MBTAViewController
    private let weatherViewController: UIViewController //TODO: WeatherViewController

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {

        // MBTA

        mbtaViewController = UIViewController()

        // Weather

        weatherViewController = UIViewController()
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
        }
        view.addSubview(mainStackView)
        mainStackView.addArrangedSubview(mbtaViewController.view)
        mainStackView.addArrangedSubview(weatherViewController.view)
        mainStackView.horizontalAnchors == view.horizontalAnchors
        mainStackView.verticalAnchors == view.safeAreaLayoutGuide.verticalAnchors
        weatherViewController.view.heightAnchor == view.heightAnchor * 0.2

        mbtaViewController.view.backgroundColor = Asset.Colors.orange.color
        weatherViewController.view.backgroundColor = Asset.Colors.day.color
    }

}
