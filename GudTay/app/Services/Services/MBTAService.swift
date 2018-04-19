//
//  MBTAService.swift
//  Services
//
//  Created by Zev Eisenberg on 4/17/18.
//

import Alamofire
import Then

public class MBTAService {

    private let client: APIClient

    public init(configuration: URLSessionConfiguration = .default, cache: FlatCache = FlatCache(), decoder: JSONDecoder = JSONDecoder()) {
        client = APIClient(baseURL: APIEnvironment.active.mbtaUrl, configuration: configuration, cache: cache, decoder: JSONDecoder().then {
            $0.keyDecodingStrategy = .convertFromSnakeCase
            $0.dateDecodingStrategy = .iso8601
        })
    }

}

extension MBTAService {

    public func getPredictions(forStop stop: Identifier<Stop>, completion: @escaping(Result<[Prediction]>) -> Void) -> RequestProtocol {
        let endpoint = MBTAEndpoint.PredictionsByStop(stop: stop)
        client.cache?.clearCache()
        return client.request(endpoint) { [weak self] (response, error) in
            if let predictions = response?.data {
                self?.client.cache?.deleteAll(Prediction.self, excluding: predictions)
                completion(.success(predictions))
            }
            else {
                completion(.failure(error ?? APIError.invalidResponse))
            }
        }
    }

}
