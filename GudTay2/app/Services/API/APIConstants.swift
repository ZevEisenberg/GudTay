//
//  APIConstants.swift
//  GudTay
//
//  Created by ZevEisenberg on 11/2/16.
//  Copyright © 2017 ZevEisenberg. All rights reserved.
//

/// APIConstants that are used in multiple places
public enum APIConstants {
    // Headers
    static let authorization = "Authorization"
    static let accept = "Accept"
    static let contentType = "Content-Type"

    // Values
    static let applicationJSON = "application/json"
    static let formEncoded = "application/x-www-form-urlencoded"

    public static let routeOfInterest: Identifier<Route> = "32"

}
