//
//  DrawingContext.swift
//  GudTay
//
//  Created by Zev Eisenberg on 1/7/19.
//

import UIKit

class DrawingContext {

    let lineColor: UIColor
    let lineWidth: CGFloat
    var lastPoints: [CGPoint] = Array(repeating: .zero, count: 4)

    init(lineColor: UIColor, lineWidth: CGFloat) {
        self.lineColor = lineColor
        self.lineWidth = lineWidth
    }

    func addPoint(_ point: CGPoint) {
        lastPoints.removeFirst()
        lastPoints.append(point)
    }

}
