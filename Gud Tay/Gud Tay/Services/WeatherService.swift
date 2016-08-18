//
//  WeatherService.swift
//  Gud Tay
//
//  Created by Zev Eisenberg on 8/7/16.
//  Copyright © 2016 Zev Eisenberg. All rights reserved.
//

import Foundation

protocol WeatherServiceType {

    static func predictions(latitude: Double, longitude: Double, completion: @escaping (APIClient.Result) -> ())

}

enum WeatherService: WeatherServiceType {

    static func predictions(latitude: Double, longitude: Double, completion: @escaping (APIClient.Result) -> ()) {
        let url = baseUrl().appendingPathComponent(Endpoints.forecast).appendingPathComponent(Constants.apiKey).appendingPathComponent("\(latitude),\(longitude)")
        APIClient.get(baseUrl: url, path: "", completion: completion)
    }

}

private extension WeatherService {

    struct Constants {

        static let apiKey = "8d8fc9bf425e2a321f364f5ae10e7d1e"
        static let host = "https://api.forecast.io/"

    }

    struct Endpoints {

        static let forecast = "forecast"

    }

    static func baseUrl() -> URL {
        return URL(string: Constants.host)!
    }

    static func getRequest(path: String, params: Dictionary<String, Any>? = nil, completion: @escaping (APIClient.Result) -> ()) {
        var params = params ?? [:]
        params["api_key"] = Constants.apiKey
        APIClient.get(baseUrl: baseUrl(), path: path, params: params, completion: completion)
    }

}

private final class DummyClass { }

enum MockWeatherService: WeatherServiceType {

    static func predictions(latitude: Double, longitude: Double, completion: @escaping (APIClient.Result) -> ()) {
        let filename = "Sample Weather API Response"
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
