//
//  ClockView.swift
//  Gud Tay
//
//  Created by Zev Eisenberg on 3/12/17.
//  Copyright © 2017 Zev Eisenberg. All rights reserved.
//

import Anchorage
import UIKit

final class ClockView: UIView {

    let faceView = UIImageView(image: #imageLiteral(resourceName: "Face"))

    // Wrappers so we can rotate the views about their centers without having
    // to adjust their .anchorPoint, which throws off Auto layout.

    let hourWrapper: UIView = {
        let hourHand = UIImageView(image: #imageLiteral(resourceName: "Hour Hand"))
        hourHand.accessibilityIdentifier = "hourHand"
        let hourWrapper = UIView(axId: "hourWrapper")
        hourWrapper.addSubview(hourHand)
        hourHand.horizontalAnchors == hourWrapper.horizontalAnchors
        hourHand.topAnchor == hourWrapper.topAnchor
        hourHand.heightAnchor == hourWrapper.heightAnchor / 2.0
        return hourWrapper
    }()

    let minuteWrapper: UIView = {
        let minuteHand = UIImageView(image: #imageLiteral(resourceName: "Minute Hand"))
        minuteHand.accessibilityIdentifier = "minuteHand"
        let minuteWrapper = UIView(axId: "minuteWrapper")
        minuteWrapper.addSubview(minuteHand)
        minuteHand.horizontalAnchors == minuteWrapper.horizontalAnchors
        minuteHand.topAnchor == minuteWrapper.topAnchor
        minuteHand.heightAnchor == minuteWrapper.heightAnchor / 2.0
        return minuteWrapper
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        // View Hierarchy

        addSubview(faceView)

        // Hour hand after minute hand, so you can see it even when they're on top of each other.
        addSubview(minuteWrapper)
        addSubview(hourWrapper)

        // Layout

        faceView.edgeAnchors == edgeAnchors

        hourWrapper.centerAnchors == centerAnchors
        minuteWrapper.centerAnchors == centerAnchors

        // Configuration

        let timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(tick), userInfo: nil, repeats: true)
        timer.tolerance = 1.0
        timer.fire()
    }

    @available(*, unavailable) required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - Private

private extension ClockView {

    @objc func tick() {
        let time = Date().clockTime()
        let rotations = time.handRotations

        hourWrapper.layer.transform = CATransform3DMakeRotation(rotations.hour, 0, 0, 1)
        minuteWrapper.layer.transform = CATransform3DMakeRotation(rotations.minute, 0, 0, 1)
    }

}

extension ClockTime {

    var asTwelveHour: ClockTime {
        return ClockTime(hours: hours % 12, minutes: minutes)
    }

    var handRotations: (hour: CGFloat, minute: CGFloat) {
        let twelveHour = asTwelveHour

        let hourRotation = CGFloat(twelveHour.allMinutes).scaled(from: 0...(60.0 * 12.0), to: 0...(.pi * 2.0))
        let minuteRotation = CGFloat(twelveHour.minutes).scaled(from: 0...60, to: 0...(.pi * 2.0))

        return (hour: hourRotation, minute: minuteRotation)
    }

}
