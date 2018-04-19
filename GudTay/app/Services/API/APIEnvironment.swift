//
//  APIEnvironment.swift
//  GudTay
//
//  Created by ZevEisenberg on 7/24/17.
//
//

import Foundation

public enum APIEnvironment {

    case develop
    case sprint
    case production

    static var active: APIEnvironment {
        switch BuildType.active {
        case .debug:        return .develop
        case .internal:     return .sprint
        case .release:      return .production
        }
    }

}

extension APIEnvironment {

    var mbtaUrl: URL {
        return URL(string: "https://api-v3.mbta.com")!
    }

    var weatherUrl: URL {
        return URL(string: "https://api.darksky.net")!
    }

}
