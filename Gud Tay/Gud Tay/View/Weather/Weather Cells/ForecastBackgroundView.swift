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

    var colorOfUpperLeadingPixel: UIColor {
        layoutIfNeeded()

        let (context, data, byteCount) = ForecastBackgroundView.createBitmapContext()
        layer.render(in: context)

        let alpha: UInt8 = data[0]
        let red: UInt8 = data[1]
        let green: UInt8 = data[2]
        let blue: UInt8 = data[3]

        data.deallocate(capacity: byteCount)

        let color = UIColor(red: CGFloat(red) / 255, green: CGFloat(green) / 255, blue: CGFloat(blue) / 255, alpha: CGFloat(alpha) / 255)
        return color
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

    class func createBitmapContext() -> (context: CGContext, bitmapData: UnsafeMutablePointer<UInt8>, bitmapDatByteCount: Int) {
        let pixelsWide = 1
        let pixelsHigh = 1

        let bytesPerRow = pixelsWide * 4
        let byteCount = bytesPerRow * Int(pixelsHigh)

        let bitmapData = malloc(byteCount)!

        let context = CGContext(
            data: bitmapData,
            width: pixelsWide,
            height: pixelsHigh,
            bitsPerComponent: 8,
            bytesPerRow: bytesPerRow,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue).rawValue)

        return (context!, bitmapData.assumingMemoryBound(to: UInt8.self), byteCount)
    }

}
