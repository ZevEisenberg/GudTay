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

    fileprivate var scrollBackTimer: Timer?

    fileprivate let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = UICollectionViewFlowLayoutAutomaticSize
        layout.estimatedItemSize = CGSize(width: 50.0, height: 205.0)
        layout.minimumInteritemSpacing = 0.0
        layout.minimumLineSpacing = 0.0

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = Colors.white
        collectionView.register(TemperatureCell.self, forCellWithReuseIdentifier: TemperatureCell.gudReuseID)
        collectionView.register(AspectImageCell.self, forCellWithReuseIdentifier: AspectImageCell.gudReuseID)
        collectionView.register(ForecastCell.self, forCellWithReuseIdentifier: ForecastCell.gudReuseID)
        collectionView.alwaysBounceHorizontal = true
        collectionView.contentInset = UIEdgeInsets(top: 0.0, left: 15.0, bottom: 0.0, right: 0.0)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()

    fileprivate let forecastBackground = ForecastBackgroundView()
    fileprivate var forecastBackgroundLeadingConstraint: NSLayoutConstraint?

    init(viewModel: WeatherViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    override func loadView() {
        view = UIView(axId: "WeatherViewController.view")

        view.addSubview(forecastBackground)
        view.addSubview(collectionView)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        forecastBackground.verticalAnchors == view.verticalAnchors
        forecastBackground.widthAnchor == CGFloat(ForecastCell.preferredWidth * 24)
        forecastBackgroundLeadingConstraint = (forecastBackground.leadingAnchor == view.leadingAnchor)

        collectionView.edgeAnchors == view.edgeAnchors

        collectionView.dataSource = self
        collectionView.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        var refreshInterval = 10.0 * 60.0
        if let intervalString = ProcessInfo.processInfo.environment[ProcessInfo.EnvironmentKey.weatherRefreshInterval.rawValue], let interval = TimeInterval(intervalString) {
            refreshInterval = interval
        }

        Timer.scheduledTimer(withTimeInterval: refreshInterval, repeats: true, block: { _ in
            self.updateBackgroundForScrollPosition()
            self.viewModel.refresh(referenceDate: Date(), calendar: .autoupdatingCurrent) { result in
                self.restartScrollBackTimer()
                switch result {
                case let .success(_, forecastBackgroundViewModel):
                    self.collectionView.reloadData()
                    self.collectionView.collectionViewLayout.invalidateLayout()
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0 / 60.0) {
                        self.updateBackgroundForScrollPosition()
                    }
                    self.forecastBackground.viewModel = forecastBackgroundViewModel
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
        case .currentIcon(let icon):
            let cell = forceCast(collectionView.dequeueReusableCell(withReuseIdentifier: AspectImageCell.gudReuseID, for: indexPath), as: AspectImageCell.self)
            cell.image = icon.image
            cell.pinnedHeight = view.frame.height
            return cell
        case .needUmbrella:
            let cell = forceCast(collectionView.dequeueReusableCell(withReuseIdentifier: AspectImageCell.gudReuseID, for: indexPath), as: AspectImageCell.self)
            cell.image = #imageLiteral(resourceName: "calvin-umbrella")
            cell.pinnedHeight = view.frame.height
            return cell
        case .hour(let time, let icon, let temp, let precipProbability):
            let cell = forceCast(collectionView.dequeueReusableCell(withReuseIdentifier: ForecastCell.gudReuseID, for: indexPath), as: ForecastCell.self)
            cell.model = (time: time, icon: icon, temp: temp, precipProbability: precipProbability)
            cell.pinnedHeight = view.frame.height
            return cell
        }
    }

}

extension WeatherViewController: UICollectionViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateBackgroundForScrollPosition()
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        restartScrollBackTimer()
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        restartScrollBackTimer()
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        restartScrollBackTimer()
    }

}

private extension WeatherViewController {

    func restartScrollBackTimer() {
        scrollBackTimer?.invalidate()
        scrollBackTimer = Timer.scheduledTimer(withTimeInterval: 45, repeats: false, block: { _ in
            self.collectionView.setContentOffset(.zero, animated: true)
            self.scrollBackTimer?.invalidate()
            self.scrollBackTimer = nil
        })
    }

    func updateBackgroundForScrollPosition() {
        guard let indexOfFirstForecastCell = viewModel.fields.index(where: {
            switch $0 {
            case .hour: return true
            default: return false
            }
        }) else {
            return
        }

        guard let frame = collectionView.layoutAttributesForItem(at: IndexPath(item: indexOfFirstForecastCell, section: 0))?.frame else {
            return
        }

        forecastBackgroundLeadingConstraint?.constant = -collectionView.contentOffset.x + frame.minX
    }

}
