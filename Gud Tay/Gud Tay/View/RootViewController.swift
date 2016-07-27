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

    private let mbtaViewController = MBTAViewController()
    private let mainStackView: UIStackView = {
        let stackView = UIStackView(axId: "mainStackView")
        stackView.axis = .vertical
        stackView.alignment = .fill
        return stackView
    }()

    private let weatherPlaceholderView = UIView(axId: "weatherPlaceholderView")

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    @available(*, unavailable) required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = UIView(axId: "rootViewController.view")
        view.backgroundColor = .white()

        view.addSubview(mainStackView)
        mainStackView.addArrangedSubview(mbtaViewController.view)
        mainStackView.addArrangedSubview(weatherPlaceholderView)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        mainStackView.horizontalAnchors == view.horizontalAnchors
        mainStackView.topAnchor == topLayoutGuide.bottomAnchor
        mainStackView.bottomAnchor == bottomLayoutGuide.topAnchor
        weatherPlaceholderView.heightAnchor == view.heightAnchor * 0.2
        weatherPlaceholderView.backgroundColor = #colorLiteral(red: 0.4120420814, green: 0.8022739887, blue: 0.9693969488, alpha: 1)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

}
