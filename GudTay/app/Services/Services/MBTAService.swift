//
//  MBTAService.swift
//  Services
//
//  Created by Zev Eisenberg on 4/17/18.
//

import Then

public class MBTAService {

    private let client: APIClient

    public init(configuration: URLSessionConfiguration = .default, decoder: JSONDecoder = JSONDecoder()) {
        client = APIClient(baseURL: APIEnvironment.active.mbtaUrl, configuration: configuration, decoder: JSONDecoder().then {
            $0.keyDecodingStrategy = .convertFromSnakeCase
            $0.dateDecodingStrategy = .iso8601
        })
    }

}

public extension MBTAService {

    func getPredictions(forStop stop: Tagged<Stop, String>, completion: @escaping(Result<[Prediction], Error>) -> Void) -> URLSessionTask {
        let endpoint = MBTAEndpoint.PredictionsByStop(stop: stop)
        return client.dataTask(endpoint) { result in
            switch result {
            case .success(let response):
                let documentBodyData = response.body.data
                let manyResourceBody = documentBodyData?.primary
                #warning("how do I get the predictions from the body?")
                completion(.success([]))
//                let predictions = manyResourceBody?.values.map(Prediction.from(_:)) ?? []
//                completion(.success(predictions))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

}
