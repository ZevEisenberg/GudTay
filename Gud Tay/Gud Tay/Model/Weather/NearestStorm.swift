//
//  NearestStorm.swift
//  Gud Tay
//
//  Created by Zev Eisenberg on 8/14/16.
//  Copyright © 2016 Zev Eisenberg. All rights reserved.
//

import JSON

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

extension NearestStorm: JSON.Representable {

    init(json: JSON.Object) throws {
        let distance: Double = json.optionalValue(key: "nearestStormDistance") ?? 0
        if distance.isPracticallyZero() {
            self = .none
        }
        else {
            let bearing: Double = try json.value(key: "nearestStormBearing")
            self = .some(distance: distance, bearing: bearing)
        }

    }

}

extension NearestStorm: JSON.Listable { }
