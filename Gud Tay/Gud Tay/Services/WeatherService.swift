//
//  WeatherService.swift
//  Gud Tay
//
//  Created by Zev Eisenberg on 8/7/16.
//  Copyright © 2016 Zev Eisenberg. All rights reserved.
//

import Foundation

protocol WeatherServiceType {

    static func predictions(latitude: Double, longitude: Double, completion: @escaping (APIClient.Result) -> Void)

}

enum WeatherServiceKind: String {

    case normal
    case mock

    var serviceType: WeatherServiceType.Type {
        switch self {
        case .normal:
            return WeatherService.self
        case .mock:
            return MockWeatherService.self
        }
    }

}

enum WeatherService: WeatherServiceType {

    static func predictions(latitude: Double, longitude: Double, completion: @escaping (APIClient.Result) -> Void) {
        let url = baseUrl().appendingPathComponent(Endpoints.forecast).appendingPathComponent(Constants.apiKey).appendingPathComponent("\(latitude),\(longitude)")
        APIClient.get(baseUrl: url, path: "", completion: completion)
    }

}

private extension WeatherService {

    struct Constants {

        static let apiKey = "4e5a1cefda62d393b23921b31d2c69dc"
        static let host = "https://api.darksky.net/"

    }

    struct Endpoints {

        static let forecast = "forecast"

    }

    static func baseUrl() -> URL {
        return URL(string: Constants.host)!
    }

    static func getRequest(path: String, params: [String: Any]? = nil, completion: @escaping (APIClient.Result) -> Void) {
        var params = params ?? [:]
        params["api_key"] = Constants.apiKey
        APIClient.get(baseUrl: baseUrl(), path: path, params: params, completion: completion)
    }

}

private final class DummyClass { }

struct MockWeatherService: WeatherServiceType {

    private static var provider = FlipFloppingWeatherFileProvider()

    static func predictions(latitude: Double, longitude: Double, completion: @escaping (APIClient.Result) -> Void) {
        let filename = provider.next()!
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

struct FlipFloppingWeatherFileProvider: Sequence, IteratorProtocol {

    private var index = [String].Index(0)

    private let fileNames = [
        "Sample Weather API Response without rain",
        "Sample Weather API Response with rain",
    ]

    mutating func next() -> String? {
        defer {
            index += 1
            if index == fileNames.count {
                index = 0
            }
        }
        return fileNames[index]
    }

}
