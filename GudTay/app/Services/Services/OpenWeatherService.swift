//
//  OpenWeatherService.swift
//  Services
//
//  Created by Zev Eisenberg on 5/28/20.
//

import Foundation
import Utilities

public final class OpenWeatherService {

    private let client: APIClient

    public init(configuration: URLSessionConfiguration = .default) {
        let decoder = with(JSONDecoder()) {
            $0.keyDecodingStrategy = .convertFromSnakeCase
            $0.dateDecodingStrategy = .secondsSince1970
        }

        client = APIClient(baseURL: APIEnvironment.active.openWeatherUrl, configuration: configuration, decoder: decoder)
    }

    public func forecast(_ completion: @escaping (Result<OpenWeatherAPI.OneCall, Error>) -> Void) {
        let endpoint = OpenWeatherEndpoint.Forecast(apiKey: Constants.apiKey, latitude: 42.3601, longitude: -71.0589)
        _ = client.dataTask(endpoint, completion: completion)
    }
}

private extension OpenWeatherService {

    enum Constants {
        static let apiKey = "The app no longer works with OpenWeatherMap, and I deleted my account, so I rebased into the history and deleted the API key. If you see this, welcome, fellow traveler. Drop me a line and let me know you saw this ❤️"
    }
}
