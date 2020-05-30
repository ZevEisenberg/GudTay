//
//  APIClient+GudTay.swift
//  GudTay
//
//  Created by ZevEisenberg on 7/24/17.
//
//

import Foundation

public extension APIClient {

    static var mbta = APIClient(baseURL: APIEnvironment.active.mbtaUrl)

}
