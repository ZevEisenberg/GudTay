//
//  CGRect+Utilities.swift
//  Utilities
//
//  Created by Zev Eisenberg on 1/7/19.
//

import CoreGraphics.CGGeometry
import UIKit

public extension CGRect {

    /// Floors the origin and ceils the size, snapping to the nearest screen pixel.
    ///
    /// - Parameter scale: a scale like you would get from UIScreen.main.scale.
    ///                    Retina screens are 2x, Super Retina or Retina HD are 3x.
    /// - Returns: an integralized version of the rect. The resulting rect will
    ///            never be smaller than the original, but it may be larger.
    func integralizedToScreenPixels(withScale scale: CGFloat = UIScreen.main.scale) -> CGRect {
        let reciprocal = 1.0 / scale
        return CGRect(
            x: origin.x.flooredToNearest(reciprocal),
            y: origin.y.flooredToNearest(reciprocal),
            width: width.ceiledToNearest(reciprocal),
            height: height.ceiledToNearest(reciprocal)
        )
    }

}
