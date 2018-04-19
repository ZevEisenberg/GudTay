//
//  Icon.swift
//  Services
//
//  Created by Zev Eisenberg on 8/14/16.
//  Copyright © 2016 Zev Eisenberg. All rights reserved.
//

import UIKit.UIImage

private final class ImageDummyClass {}

public enum Icon: String {

    case clearDay = "clear-day"
    case clearNight = "clear-night"
    case rain = "rain"
    case snow = "snow"
    case sleet = "sleet"
    case wind = "wind"
    case fog = "fog"
    case cloudy = "cloudy"
    case partlyCloudyDay = "partly-cloudy-day"
    case partlyCloudyNight = "partly-cloudy-night"

    public var image: UIImage {
        return UIImage(named: rawValue, in: Bundle(for: ImageDummyClass.self), compatibleWith: nil)!
    }

    public var smallImage: UIImage {
        switch self {
        case .clearDay:
            return Asset.Small.clearDay.image
        case .clearNight:
            return Asset.Small.clearNight.image
        default:
            return image
        }
    }

}
