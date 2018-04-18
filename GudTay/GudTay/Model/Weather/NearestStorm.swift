//
//  NearestStorm.swift
//  Gud Tay
//
//  Created by Zev Eisenberg on 8/14/16.
//  Copyright © 2016 Zev Eisenberg. All rights reserved.
//

enum NearestStorm {

    case none

    /// - `distance`: The distance to the nearest storm in miles. (This value is very approximate and
    /// should not be used in scenarios requiring accurate results. In particular, a storm
    /// distance of zero doesn’t necessarily refer to a storm at the requested location,
    /// but rather a storm in the vicinity of that location.)
    ///
    /// - `direction`: The direction of the nearest storm in degrees, with true north at 0° and progressing clockwise.
    /// (If `distance` is zero, then this value will not be defined. The caveats that apply
    /// to `distance` also apply to this value.)
    case some(distance: Double, bearing: Double)

}

extension NearestStorm: Decodable {

    private enum CodingKeys: String, CodingKey {
        case distance = "nearestStormDistance"
        case bearing = "nearestStormBearing"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let distance = try values.decodeIfPresent(Double.self, forKey: .distance) ?? 0
        if distance.isPracticallyZero() {
            self = .none
        }
        else {
            let bearing = try values.decode(Double.self, forKey: .bearing)
            self = .some(distance: distance, bearing: bearing)
        }
    }

}