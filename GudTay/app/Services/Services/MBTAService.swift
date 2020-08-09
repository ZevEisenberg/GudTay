//
//  MBTAService.swift
//  Services
//
//  Created by Zev Eisenberg on 4/17/18.
//

import Foundation
import Utilities

public class MBTAService {

    private let client: APIClient

    public init(configuration: URLSessionConfiguration = .default, decoder: JSONDecoder = JSONDecoder()) {
        client = APIClient(baseURL: APIEnvironment.active.mbtaUrl, configuration: configuration, decoder: with(JSONDecoder()) {
            $0.keyDecodingStrategy = .convertFromSnakeCase
            $0.dateDecodingStrategy = .iso8601
        })
    }

}

public extension MBTAService {

    func getPredictions(forStop stop: Tagged<Stop, String>, completion: @escaping(Result<[Prediction], Error>) -> Void) -> URLSessionTask {
        let endpoint = MBTAEndpoint.PredictionsByStop(stop: stop)
        return client.dataTask(endpoint) { result in
            completion(result.flatMap(Prediction.from(document:)))
        }
    }

}
