//
//  MBTAService.swift
//  Services
//
//  Created by Zev Eisenberg on 4/17/18.
//

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

public extension MBTAService {

    func getPredictions(forStop stop: Identifier<Stop>, completion: @escaping(Result<[Prediction], Error>) -> Void) -> URLSessionTask {
        let endpoint = MBTAEndpoint.PredictionsByStop(stop: stop)
        client.cache?.clearCache()
        return client.dataTask(endpoint) { [weak self] result in
            switch result {
            case .success(let predictions):
                self?.client.cache?.deleteAll(Prediction.self, excluding: predictions.data)
                completion(.success(predictions.data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

}
