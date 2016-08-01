//
//  MBTAService.swift
//  Gud Tay
//
//  Created by Zev Eisenberg on 7/29/16.
//  Copyright © 2016 Zev Eisenberg. All rights reserved.
//

protocol MBTAServiceType {

    static func predictionsByStop(stopId: String, completion: (APIClient.Result) -> ())

}

enum MBTAService: MBTAServiceType {

    static func predictionsByStop(stopId: String, completion: (APIClient.Result) -> ()) {
        let params = ["stop": stopId]
        getRequest(path: Endpoints.predictionsByStop, params: params, completion: completion)
    }

}

private extension MBTAService {

    struct Constants {

        static let apiKey = "40jKQwmnXk-4slxceBfcEA"
        static let username = "ZevEisenberg"
        static let appName = "status-board-mbta"
        static let host = "https://realtime.mbta.com"
        static let commonPath = "developer/api/v2"

    }

    struct Endpoints {

        static let predictionsByStop = "predictionsbystop"

    }

    static func baseUrl() -> URL {
        let hostUrl = URL(string: Constants.host)!

        return hostUrl.appendingPathComponent(Constants.commonPath)
    }

    static func getRequest(path: String, params: Dictionary<String, AnyObject>? = nil, completion: (APIClient.Result) -> ()) {
        var params = params ?? [:]
        params["api_key"] = Constants.apiKey
        APIClient.get(baseUrl: baseUrl(), path: path, params: params, completion: completion)
    }

}
