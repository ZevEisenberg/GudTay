//
//  ClockView.swift
//  GudTay
//
//  Created by Zev Eisenberg on 3/12/17.
//  Copyright © 2017 Zev Eisenberg. All rights reserved.
//

import Anchorage
import Swiftilities
import Then
import UIKit

final class ClockView: UIView {

    let faceView = UIImageView(image: Asset.Clock.face.image).then {
        $0.accessibilityIdentifier = "clock face"
        $0.setContentHuggingPriority(.required, for: .horizontal)
        $0.setContentHuggingPriority(.required, for: .vertical)
    }

    // Wrappers so we can rotate the views about their centers without having
    // to adjust their .anchorPoint, which throws off Auto layout.

    let hourWrapper: UIView = {
        let hourHand = UIImageView(image: Asset.Clock.hourHand.image)
        hourHand.accessibilityIdentifier = "hourHand"
        let hourWrapper = UIView(axId: "hourWrapper")
        hourWrapper.addSubview(hourHand)
        hourHand.horizontalAnchors == hourWrapper.horizontalAnchors
        hourHand.topAnchor == hourWrapper.topAnchor
        hourHand.heightAnchor == hourWrapper.heightAnchor / 2.0
        return hourWrapper
    }()

    let minuteWrapper: UIView = {
        let minuteHand = UIImageView(image: Asset.Clock.minuteHand.image)
        minuteHand.accessibilityIdentifier = "minuteHand"
        let minuteWrapper = UIView(axId: "minuteWrapper")
        minuteWrapper.addSubview(minuteHand)
        minuteHand.horizontalAnchors == minuteWrapper.horizontalAnchors
        minuteHand.topAnchor == minuteWrapper.topAnchor
        minuteHand.heightAnchor == minuteWrapper.heightAnchor / 2.0
        return minuteWrapper
    }()

    let secondWrapper: UIView = {
        let secondHand = UIImageView(image: Asset.Clock.secondHand.image)
        secondHand.accessibilityIdentifier = "secondHand"
        let secondWrapper = UIView(axId: "secondWrapper")
        secondWrapper.addSubview(secondHand)
        secondHand.horizontalAnchors == secondWrapper.horizontalAnchors
        secondHand.topAnchor == secondWrapper.topAnchor
        secondHand.heightAnchor == secondWrapper.heightAnchor / 2.0
        return secondWrapper
    }()

    let pivot = UIImageView(image: Asset.Clock.pivot.image).then {
        $0.accessibilityIdentifier = "pivot"
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        // View Hierarchy

        addSubview(faceView)

        // Same order as a real clock
        addSubview(hourWrapper)
        addSubview(minuteWrapper)
        addSubview(secondWrapper)
        addSubview(pivot)

        // Layout

        faceView.edgeAnchors == edgeAnchors

        hourWrapper.centerAnchors == centerAnchors
        minuteWrapper.centerAnchors == centerAnchors
        secondWrapper.centerAnchors == centerAnchors

        pivot.centerAnchors == centerAnchors

        // Configuration

        let timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
        timer.tolerance = 0.05
        // Start the second hand in the right place to start
        tick(animated: false)
    }

    @available(*, unavailable) required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - Private

private extension ClockView {

    @objc func timerFired() {
        tick(animated: true)
    }

    func tick(animated: Bool) {
        let time = Date().clockTime()
        let rotations = time.handRotations

        hourWrapper.layer.transform = CATransform3DMakeRotation(rotations.hour, 0, 0, 1)
        minuteWrapper.layer.transform = CATransform3DMakeRotation(rotations.minute, 0, 0, 1)

        let oldSecondTransform = secondWrapper.layer.transform
        secondWrapper.layer.transform = CATransform3DMakeRotation(rotations.second, 0, 0, 1)
        if animated {
            let newSecondTransform = CATransform3DMakeRotation(rotations.second, 0, 0, 1)
            let animation = CASpringAnimation(keyPath: #keyPath(CALayer.transform))
            animation.damping = 100
            animation.stiffness = 10_000
            animation.fromValue = oldSecondTransform
            animation.toValue = newSecondTransform
            animation.duration = 0.5
            secondWrapper.layer.add(animation, forKey: "secondTick")
        }
    }

}

extension ClockTime {

    var asTwelveHour: ClockTime {
        return ClockTime(hours: hours % 12, minutes: minutes, seconds: seconds)
    }

    var handRotations: (hour: CGFloat, minute: CGFloat, second: CGFloat) {
        let twelveHour = asTwelveHour

        let hourRotation = CGFloat(twelveHour.allSeconds).scaled(from: 0...(60 * 60 * 12), to: 0...(.pi * 2.0))
        let minuteRotation = CGFloat(twelveHour.minutesInSeconds).scaled(from: 0...(60 * 60), to: 0...(.pi * 2.0))
        let secondRotation = CGFloat(twelveHour.seconds).scaled(from: 0...60, to: 0...(.pi * 2))

        return (hour: hourRotation, minute: minuteRotation, second: secondRotation)
    }

}
