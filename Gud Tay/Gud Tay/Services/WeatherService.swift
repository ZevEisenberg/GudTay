//
//  WeatherService.swift
//  Gud Tay
//
//  Created by Zev Eisenberg on 8/7/16.
//  Copyright © 2016 Zev Eisenberg. All rights reserved.
//

import Foundation

protocol WeatherServiceType {

    init()
    func predictions<Value: Decodable>(latitude: Double, longitude: Double, completion: @escaping (APIClient.Result<Value>) -> Void)

}

enum WeatherServiceKind: String {

    case normal
    case mock

    var serviceType: WeatherServiceType.Type {
        switch self {
        case .normal:
            return WeatherService.self
        case .mock:
            return MockWeatherService<FlipFlopping>.self
        }
    }

}

struct WeatherService: WeatherServiceType {

    func predictions<Value: Decodable>(latitude: Double, longitude: Double, completion: @escaping (APIClient.Result<Value>) -> Void) {
        let url = WeatherService.baseUrl().appendingPathComponent(Endpoints.forecast).appendingPathComponent(Constants.apiKey).appendingPathComponent("\(latitude),\(longitude)")
        APIClient.getJson(baseUrl: url, path: "", completion: completion)
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

    static func getRequest<Value: Decodable>(path: String, params: [String: Any]? = nil, completion: @escaping (APIClient.Result<Value>) -> Void) {
        var params = params ?? [:]
        params["api_key"] = Constants.apiKey
        APIClient.getJson(baseUrl: baseUrl(), path: path, params: params, completion: completion)
    }

}

private final class DummyClass { }

class MockWeatherService<Stubs: WeatherStubs>: WeatherServiceType {

    private var provider = WeatherFileProvider<Stubs>()

    required init() { }

    func predictions<Value: Decodable>(latitude: Double, longitude: Double, completion: @escaping (APIClient.Result<Value>) -> Void) {
        let filename = provider.next()!
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
            assertionFailure("Error getting contents of \(filename)\(ext): \(e)")
        }

        do {
            let forecast = try JSONDecoder().decode(Value.self, from: data)
            completion(.success(forecast))
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

protocol WeatherStubs {
    var fileNames: [String] { get }
    init()
}

struct WeatherFileProvider<Stubs: WeatherStubs>: Sequence, IteratorProtocol {

    private var stubs = Stubs()

    private var index: Int = 0

    mutating func next() -> String? {
        defer {
            index += 1
            if index == stubs.fileNames.count {
                index = 0
            }
        }
        return stubs.fileNames[index]
    }

}

struct WithRain: WeatherStubs {

    let fileNames = [
        "Sample Weather API Response with rain",
        ]

}

struct FlipFlopping: WeatherStubs {

    let fileNames = [
        "Sample Weather API Response without rain",
        "Sample Weather API Response with rain",
        ]

}

struct JustAfterSunset: WeatherStubs {

    let fileNames = [
        "Sample Weather API Response just after sunset",
    ]

}

struct JustAfterMidnight: WeatherStubs {

    let fileNames = [
        "Sample Weather API Response just after midnight",
        ]

}
