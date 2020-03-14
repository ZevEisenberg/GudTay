//
//  APIEndpoint.swift
//  GudTay
//
//  Created by ZevEisenberg on 11/1/16.
//  Copyright © 2017 ZevEisenberg. All rights reserved.
//

import Foundation

protocol APIEndpoint: NetworkLoggable {
    associatedtype ResponseType

    var path: String { get }
    var queryItems: [URLQueryItem]? { get }
    var method: String { get }
    var parameters: [String: Any]? { get }
    var headers: [String: String] { get }
}

extension APIEndpoint {

    var parameters: [String: Any]? {
        nil
    }

    var queryItems: [URLQueryItem]? {
        nil
    }

    var headers: [String: String] {
        [:]
    }

}
