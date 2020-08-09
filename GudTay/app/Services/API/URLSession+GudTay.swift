//
//  URLSession+GudTay.swift
//  GudTay
//
//  Created by ZevEisenberg on 11/3/16.
//  Copyright © 2017 ZevEisenberg. All rights reserved.
//

import Foundation

struct UnknownError: Error {
    let request: URLRequest
    let response: URLResponse?
}

extension URLSession {

    @discardableResult
    func dataTask<Endpoint: APIEndpoint>(_ baseURL: URL, endpoint: Endpoint, subsystem: String, decoder: JSONDecoder, completion: @escaping (Result<Endpoint.ResponseType, Error>) -> Void) -> URLSessionTask where Endpoint.ResponseType: Decodable {
        let request = self.request(baseURL, endpoint: endpoint)
        let task = dataTask(with: request) { (data, response, error) in
            switch (data, error) {
            case (.some(let data), _):
                LogService.add(apiSnapshot: data, forSubsystem: subsystem)
                completion(Result { try decoder.decode(Endpoint.ResponseType.self, from: data) })
            case (_, .some(let error)):
                completion(.failure(error))
            case (.none, .none):
                completion(.failure(UnknownError(request: request, response: response)))
            }
        }
        task.resume()
        return task
    }

}

private extension URLSession {

    func request<Endpoint: APIEndpoint>(_ baseURL: URL, endpoint: Endpoint) -> URLRequest {
        let endpointURL = baseURL.appendingPathComponent(endpoint.path)
        guard
            let url: URL = {
                var urlComponents = URLComponents(url: endpointURL, resolvingAgainstBaseURL: true)
                urlComponents?.queryItems = endpoint.queryItems
                return urlComponents?.url
            }()
            else {
                fatalError("Invalid Path Specification")
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method
        for header in endpoint.headers {
            request.setValue(header.value, forHTTPHeaderField: header.key)
        }

        DispatchQueue.global().async {
            endpoint.log(request)
        }
        return request
    }

}
