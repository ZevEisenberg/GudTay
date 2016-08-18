//
//  RootViewController.swift
//  Gud Tay
//
//  Created by Zev Eisenberg on 7/24/16.
//  Copyright © 2016 Zev Eisenberg. All rights reserved.
//

import UIKit
import Anchorage

final class RootViewController: UIViewController {

    private let mbtaViewController = MBTAViewController(viewModel: MBTAViewModel(serviceType: MBTAService.self))
    private let weatherViewController = WeatherViewController(viewModel: WeatherViewModel(serviceType: WeatherService.self))

    private let mainStackView: UIStackView = {
        let stackView = UIStackView(axId: "mainStackView")
        stackView.axis = .vertical
        stackView.alignment = .fill
        return stackView
    }()

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        mbtaViewController.errorHandler = { message in
            LogService.add(message: message)
        }
    }

    @available(*, unavailable) required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = UIView(axId: "rootViewController.view")
        view.backgroundColor = .white

        view.addSubview(mainStackView)
        mainStackView.addArrangedSubview(mbtaViewController.view)
        mainStackView.addArrangedSubview(weatherViewController.view)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        mainStackView.horizontalAnchors == view.horizontalAnchors
        mainStackView.topAnchor == topLayoutGuide.bottomAnchor
        mainStackView.bottomAnchor == bottomLayoutGuide.topAnchor
        weatherViewController.view.heightAnchor == view.heightAnchor * 0.2
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

}
