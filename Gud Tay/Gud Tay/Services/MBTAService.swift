//
//  MBTAService.swift
//  Gud Tay
//
//  Created by Zev Eisenberg on 7/29/16.
//  Copyright © 2016 Zev Eisenberg. All rights reserved.
//

enum MBTAService {

    static func stopsNearHome(completion: (APIClient.Result) -> ()) {
        let params = ["lat": Constants.lat, "lon": Constants.lon]

        getRequest(path: Endpoints.stopsByLocation, params: params, completion: completion)
    }

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
        static let lat = "42.385081"
        static let lon = "-71.077848"

    }

    struct Endpoints {

        static let stopsByLocation = "stopsbylocation"
        static let predictionsByStop = "predictionsbystop"

    }

    static func baseUrl() -> URL {
        let hostUrl = URL(string: Constants.host)!
        guard let commonUrl = try? hostUrl.appendingPathComponent(Constants.commonPath) else {
            preconditionFailure()
        }

        return commonUrl
    }

    static func getRequest(path: String, params: Dictionary<String, AnyObject>? = nil, completion: (APIClient.Result) -> ()) {
        var params = params ?? [:]
        params["api_key"] = Constants.apiKey
        APIClient.get(baseUrl: baseUrl(), path: path, params: params, completion: completion)
    }

}
