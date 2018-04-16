//
//  APIClient+GudTay.swift
//  GudTay
//
//  Created by ZevEisenberg on 7/24/17.
//
//

import Foundation

extension APIClient {

    public static var shared = APIClient(baseURL: {
        let baseURL: URL
        switch APIEnvironment.active {
        case .develop:
            baseURL = URL(string: "https://GudTay-dev.raizlabs.xyz")!
        case .sprint:
            baseURL = URL(string: "https://GudTay-sprint.raizlabs.xyz")!
        case .production:
            fatalError("Specify the release server")
        }
        return baseURL
    }())

}
