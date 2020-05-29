//
//  WeatherService.swift
//  GudTay
//
//  Created by Zev Eisenberg on 8/7/16.
//  Copyright © 2016 Zev Eisenberg. All rights reserved.
//

import Then

public protocol WeatherServiceProtocol {

    init(configuration: URLSessionConfiguration, decoder: JSONDecoder)
    func predictions(_ completion: @escaping (Result<WeatherForecast, Error>) -> Void)

}

public final class WeatherService: WeatherServiceProtocol {

    private let client: APIClient

    public init(configuration: URLSessionConfiguration = .default, decoder: JSONDecoder = JSONDecoder()) {
        client = APIClient(baseURL: APIEnvironment.active.weatherUrl, configuration: configuration, cache: nil, decoder: JSONDecoder().then {
            $0.keyDecodingStrategy = .useDefaultKeys
            $0.dateDecodingStrategy = .custom({ decoder -> Date in
                let container = try decoder.singleValueContainer()
                let interval = try container.decode(TimeInterval.self)
                return Date(timeIntervalSince1970: interval)
            })
        })
    }

    public func predictions(_ completion: @escaping (Result<WeatherForecast, Error>) -> Void) {
        let endpoint = WeatherEndpoint.Forecast(apiKey: Constants.apiKey, latitude: 42.3601, longitude: -71.0589)
        _ = client.dataTask(endpoint, completion: completion)
    }

}

private extension WeatherService {

    enum Constants {

        static let apiKey = "4e5a1cefda62d393b23921b31d2c69dc"

    }

}

//private final class DummyClass { }
//
//class MockWeatherService<Stubs: WeatherStubs>: WeatherServiceType {
//
//    private var provider = WeatherFileProvider<Stubs>()
//
//    required init() { }
//
//    func predictions<Value: Decodable>(latitude: Double, longitude: Double, completion: @escaping (APIClient.Result<Value>) -> Void) {
//        let filename = provider.next()!
//        let ext = "json"
//        guard let url = Bundle(for: DummyClass.self).url(forResource: filename, withExtension: ext) else {
//            assertionFailure("Could not find URL of \(filename).\(ext)")
//            return
//        }
//
//        var data: Data! = nil
//        do {
//            data = try Data(contentsOf: url)
//        }
//        catch let e {
//            assertionFailure("Error getting contents of \(filename)\(ext): \(e)")
//        }
//
//        do {
//            let forecast = try JSONDecoder().decode(Value.self, from: data)
//            completion(.success(forecast))
//        }
//        catch let error as DecodingError {
//            switch error {
//            case let .dataCorrupted(context):
//                assertionFailure("data corrupted: \(context)")
//            case let .keyNotFound(key, context):
//                assertionFailure("key \(key) not found: \(context)")
//            case let .typeMismatch(theType, context):
//                assertionFailure("type mismatch: \(theType): \(context)")
//            case let .valueNotFound(type, context):
//                assertionFailure("value not found: \(type): \(context)")
//            }
//        }
//        catch {
//            assertionFailure("Could not decode JSON: \(error)")
//        }
//
//    }
//
//}
//
//protocol WeatherStubs {
//    var fileNames: [String] { get }
//    init()
//}
//
//struct WeatherFileProvider<Stubs: WeatherStubs>: Sequence, IteratorProtocol {
//
//    private var stubs = Stubs()
//
//    private var index: Int = 0
//
//    mutating func next() -> String? {
//        defer {
//            index += 1
//            if index == stubs.fileNames.count {
//                index = 0
//            }
//        }
//        return stubs.fileNames[index]
//    }
//
//}
//
//struct WithRain: WeatherStubs {
//
//    let fileNames = [
//        "Sample Weather API Response with rain",
//        ]
//
//}
//
//struct FlipFlopping: WeatherStubs {
//
//    let fileNames = [
//        "Sample Weather API Response without rain",
//        "Sample Weather API Response with rain",
//        ]
//
//}
//
//struct JustAfterSunset: WeatherStubs {
//
//    let fileNames = [
//        "Sample Weather API Response just after sunset",
//        ]
//
//}
//
//struct JustAfterMidnight: WeatherStubs {
//
//    let fileNames = [
//        "Sample Weather API Response just after midnight",
//        ]
//
//}
//
