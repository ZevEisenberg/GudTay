//
//  Icon.swift
//  Gud Tay
//
//  Created by Zev Eisenberg on 8/14/16.
//  Copyright © 2016 Zev Eisenberg. All rights reserved.
//

import UIKit.UIImage

enum Icon: String {

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

    var image: UIImage {
        return UIImage(named: rawValue)!
    }

    var smallImage: UIImage {
        switch self {
        case .clearDay:
            return #imageLiteral(resourceName: "clear-day-small")
        case .clearNight:
            return #imageLiteral(resourceName: "clear-night-small")
        default:
            return image
        }
    }

}
