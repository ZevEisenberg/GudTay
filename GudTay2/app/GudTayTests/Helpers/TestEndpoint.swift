//
//  RandomEndpoint.swift
//  GudTay
//
//  Created by ZevEisenberg on 11/3/16.
//  Copyright © 2017 ZevEisenberg. All rights reserved.
//

import Alamofire
@testable import GudTay
@testable import Services

struct TestEndpoint: APIEndpoint {
    typealias ResponseType = [TestEndpointResult]
    var path: String { return "predictions" }
    var method: HTTPMethod { return .get }
    var encoding: ParameterEncoding { return URLEncoding.default }
    var parameters: JSONObject? { return [:] }
    var headers: HTTPHeaders { return [:] }

}

struct TestEndpointResult: Decodable {

    let value: String

}
