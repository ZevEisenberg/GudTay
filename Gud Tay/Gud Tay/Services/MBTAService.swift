//
//  MBTAService.swift
//  Gud Tay
//
//  Created by Zev Eisenberg on 7/29/16.
//  Copyright © 2016 Zev Eisenberg. All rights reserved.
//

import Foundation

protocol MBTAServiceType {

    static func predictionsByStop(stopId: String, completion: @escaping (APIClient.Result) -> Void)

}

enum MBTAServiceKind: String {

    case normal
    case mock

    var serviceType: MBTAServiceType.Type {
        switch self {
        case .normal:
            return MBTAService.self
        case .mock:
            return MockMBTAService.self
        }
    }

}

enum MBTAService: MBTAServiceType {

    static func predictionsByStop(stopId: String, completion: @escaping (APIClient.Result) -> Void) {
        let params = ["stop": stopId] as [String: Any]
        MBTAService.getRequest(path: Endpoints.predictionsByStop, params: params, completion: completion)
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

    static func getRequest(path: String, params: [String: Any]? = nil, completion: @escaping (APIClient.Result) -> Void) {
        var params = params ?? [:]
        params["api_key"] = Constants.apiKey
        APIClient.get(baseUrl: baseUrl(), path: path, params: params, completion: completion)
    }

}

private final class DummyClass { }

enum MockMBTAService: MBTAServiceType {

    static func predictionsByStop(stopId: String, completion: @escaping (APIClient.Result) -> Void) {
        assert(stopId == "place-sull")
        let filename = "Sample MBTA API Response"
        let ext = "json"
        guard let url = Bundle(for: DummyClass.self).url(forResource: filename, withExtension: ext) else {
            assertionFailure("Could not find URL of \(filename).\(ext)")
            return
        }

        var jsonData: Data! = nil
        do {
            jsonData = try Data(contentsOf: url)
        }
        catch let e {
            assertionFailure("Error getting contents of \(filename)\(ext): \(e)")
        }

        var deserialized: Any! = nil
        do {
            deserialized = try JSONSerialization.jsonObject(with: jsonData, options: [])
        }
        catch let e {
            assertionFailure("Error deserializing JSON data: \(e)")
        }

        guard let jsonObject = deserialized as? JSONObject else {
            assertionFailure("Could not convert deserialized JSON to a JSONObject: \(deserialized)")
            return
        }

        completion(.success(jsonObject))
    }

}
