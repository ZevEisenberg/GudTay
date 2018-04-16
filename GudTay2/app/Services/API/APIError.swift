//
//  APIError.swift
//  GudTay
//
//  Created by ZevEisenberg on 11/1/16.
//  Copyright © 2017 ZevEisenberg. All rights reserved.
//

public enum APIError: Error {
    case tokenExpired
    case invalidCredentials
    case invalidResponse
    case server(code: Int)
}
