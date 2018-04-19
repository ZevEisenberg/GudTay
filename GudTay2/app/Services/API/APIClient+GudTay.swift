//
//  APIClient+GudTay.swift
//  GudTay
//
//  Created by ZevEisenberg on 7/24/17.
//
//

import Foundation

extension APIClient {

    public static var mbta = APIClient(baseURL: APIEnvironment.active.mbtaUrl, cache: FlatCache())

}
