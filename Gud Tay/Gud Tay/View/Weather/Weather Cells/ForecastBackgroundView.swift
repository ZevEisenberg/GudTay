//
//  ForecastBackgroundView.swift
//  Gud Tay
//
//  Created by Zev Eisenberg on 8/19/16.
//  Copyright © 2016 Zev Eisenberg. All rights reserved.
//

import UIKit
import Anchorage

class ForecastBackgroundView: UIView {

    // Public Properties

    var viewModel: ForecastBackgroundViewModel? {
        didSet {
            if let viewModel = viewModel {
                updateView(viewModel: viewModel)
            }

        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
    }

    @available(*, unavailable) required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateFrames()
    }

}

private extension ForecastBackgroundView {

    func updateView(viewModel: ForecastBackgroundViewModel) {
        for view in subviews {
            view.removeFromSuperview()
        }

        for (index, interval) in viewModel.eventEndpoints(calendar: .autoupdatingCurrent).enumerated() {
            let view = SunIntervalView(interval: interval.kind)
            view.tag = index
            addSubview(view)
        }
        updateFrames()
    }

    func updateFrames() {
        guard let intervals = viewModel?.eventEndpoints(calendar: .autoupdatingCurrent) else {
            return
        }

        let totalWidth = bounds.width
        let height = bounds.height
        let realRange = 0...totalWidth
        let normalRange = CGFloat(0)...CGFloat(1)

        subviews.filter { $0 is SunIntervalView }.forEach { intervalView in
            let interval = intervals[intervalView.tag]

            let realStart = interval.start.scaled(from: normalRange, to: realRange)
            let realEnd = interval.end.scaled(from: normalRange, to: realRange)

            let realWidth = realEnd - realStart

            let frame = CGRect(
                x: realStart,
                y: 0,
                width: realWidth,
                height: height)
            intervalView.frame = frame
        }
    }

}
