//
//  WeatherViewController.swift
//  Gud Tay
//
//  Created by Zev Eisenberg on 8/18/16.
//  Copyright © 2016 Zev Eisenberg. All rights reserved.
//

import UIKit
import Anchorage

final class WeatherViewController: RefreshableViewController {

    fileprivate let viewModel: WeatherViewModel

    fileprivate let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = UICollectionViewFlowLayoutAutomaticSize
        layout.estimatedItemSize = CGSize(width: 50.0, height: 205.0)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = Colors.white
        collectionView.register(TemperatureCell.self, forCellWithReuseIdentifier: TemperatureCell.gudReuseID)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: UICollectionViewCell.gudReuseID)
        collectionView.alwaysBounceHorizontal = true
        collectionView.contentInset = UIEdgeInsets(top: 0.0, left: 15.0, bottom: 0.0, right: 0.0)
        return collectionView
    }()

    init(viewModel: WeatherViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    override func loadView() {
        view = UIView(axId: "WeatherViewController.view")

        view.addSubview(collectionView)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.edgeAnchors == view.edgeAnchors

        collectionView.dataSource = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        Timer.scheduledTimer(withTimeInterval: 30.0 * 60.0, repeats: true, block: { _ in
            self.viewModel.refresh() { result in
                switch result {
                case .success:
                    self.collectionView.reloadData()
                case .failure(let error):
                    self.processRefreshError(error)
                }
            }
        }).fire() // fire once initially
    }

}

extension WeatherViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.fields.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let field = viewModel.fields[indexPath.item]

        switch field {
        case .temperatures(let current, let high, let low):
            let cell = forceCast(collectionView.dequeueReusableCell(withReuseIdentifier: TemperatureCell.gudReuseID, for: indexPath), as: TemperatureCell.self)
            cell.temps = (current: current, high: high, low: low)
            cell.pinnedHeight = view.frame.height
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UICollectionViewCell.gudReuseID, for: indexPath)
            cell.contentView.backgroundColor = Colors.random
            cell.contentView.heightAnchor == view.frame.height
            cell.contentView.widthAnchor == 50.0
            return cell
        }
    }

}
