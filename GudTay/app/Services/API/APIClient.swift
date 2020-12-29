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
    let decoder: JSONDecoder

    public init(baseURL: URL, configuration: URLSessionConfiguration = .default, decoder: JSONDecoder = JSONDecoder()) {
        self.baseURL = baseURL
        self.decoder = decoder
        configuration.httpAdditionalHeaders = configuration.httpAdditionalHeaders ?? [:]
        configuration.httpAdditionalHeaders?[APIConstants.accept] = APIConstants.applicationJSON
        session = URLSession(configuration: configuration)
    }
}

extension APIClient {

    @discardableResult
    func dataTask<Endpoint: APIEndpoint>(_ endpoint: Endpoint, subsystem: String, completion: @escaping (Result<Endpoint.ResponseType, Error>) -> Void) -> URLSessionTask where Endpoint.ResponseType: Decodable {
        session.dataTask(baseURL, endpoint: endpoint, subsystem: subsystem, decoder: decoder) { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }

}
