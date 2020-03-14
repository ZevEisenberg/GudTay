//
//  APIClient.swift
//  GudTay
//
//  Created by ZevEisenberg on 11/1/16.
//  Copyright © 2017 ZevEisenberg. All rights reserved.
//

import Foundation

public class APIClient {
    let session: URLSession
    let baseURL: URL
    let cache: FlatCache?
    let decoder: JSONDecoder

    public init(baseURL: URL, configuration: URLSessionConfiguration = .default, cache: FlatCache?, decoder: JSONDecoder = JSONDecoder()) {
        self.baseURL = baseURL
        self.cache = cache
        self.decoder = decoder
        decoder.cache = cache
        configuration.httpAdditionalHeaders?[APIConstants.accept] = APIConstants.applicationJSON
        session = URLSession(configuration: configuration)
    }
}

extension APIClient {

    @discardableResult
    func dataTask<Endpoint: APIEndpoint>(_ endpoint: Endpoint, completion: @escaping (Result<Endpoint.ResponseType, Error>) -> Void) -> URLSessionTask where Endpoint.ResponseType: Decodable {
        session.dataTask(baseURL, endpoint: endpoint, decoder: decoder) { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }

}
