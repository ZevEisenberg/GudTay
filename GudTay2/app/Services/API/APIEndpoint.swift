//
//  APIEndpoint.swift
//  GudTay
//
//  Created by ZevEisenberg on 11/1/16.
//  Copyright © 2017 ZevEisenberg. All rights reserved.
//

import Alamofire

protocol APIEndpoint: NetworkLoggable {
    associatedtype ResponseType

    var path: String { get }
    typealias QueryParam = (String, String)
    var queryParams: [QueryParam]? { get }
    var method: HTTPMethod { get }
    var encoding: ParameterEncoding { get }
    var parameters: Parameters? { get }
    var headers: HTTPHeaders { get }
}

extension APIEndpoint {

    var encoding: ParameterEncoding {
        return JSONEncoding.default
    }

    var parameters: Parameters? {
        return nil
    }

    var queryParams: [QueryParam]? {
        return nil
    }

    var headers: HTTPHeaders {
        return [:]
    }

}
