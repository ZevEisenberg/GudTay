//
//  MBTAService.swift
//  Gud Tay
//
//  Created by Zev Eisenberg on 7/29/16.
//  Copyright © 2016 Zev Eisenberg. All rights reserved.
//

import Foundation

protocol MBTAServiceType {

    static func predictionsByStop<Value: Decodable>(stopId: String, completion: @escaping (APIClient.Result<Value>) -> Void)

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

    static func predictionsByStop<Value: Decodable>(stopId: String, completion: @escaping (APIClient.Result<Value>) -> Void) {
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

    static func getRequest<Value: Decodable>(path: String, params: [String: Any]? = nil, completion: @escaping (APIClient.Result<Value>) -> Void) {
        var params = params ?? [:]
        params["api_key"] = Constants.apiKey
        APIClient.getJson(baseUrl: baseUrl(), path: path, params: params, completion: completion)
    }

}

private final class DummyClass { }

enum MockMBTAService: MBTAServiceType {

    static func predictionsByStop<Value: Decodable>(stopId: String, completion: @escaping (APIClient.Result<Value>) -> Void) {
        assert(stopId == "place-sull")
        let filename = "Sample MBTA API Response"
        let ext = "json"
        guard let url = Bundle(for: DummyClass.self).url(forResource: filename, withExtension: ext) else {
            assertionFailure("Could not find URL of \(filename).\(ext)")
            return
        }

        var data: Data! = nil
        do {
            data = try Data(contentsOf: url)
        }
        catch let e {
            assertionFailure("Error getting contents of \(filename).\(ext): \(e)")
        }

        do {
            let stop = try JSONDecoder().decode(Value.self, from: data)
            completion(.success(stop))
        }
        catch let error as DecodingError {
            switch error {
            case let .dataCorrupted(context):
                assertionFailure("data corrupted: \(context)")
            case let .keyNotFound(key, context):
                assertionFailure("key \(key) not found: \(context)")
            case let .typeMismatch(theType, context):
                assertionFailure("type mismatch: \(theType): \(context)")
            case let .valueNotFound(type, context):
                assertionFailure("value not found: \(type): \(context)")
            }
        }
        catch {
            assertionFailure("Could not decode JSON: \(error)")
        }
    }

}
