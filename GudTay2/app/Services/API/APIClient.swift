//
//  APIClient.swift
//  GudTay
//
//  Created by ZevEisenberg on 11/1/16.
//  Copyright © 2017 ZevEisenberg. All rights reserved.
//

import Alamofire

public class APIClient {
    let manager: Alamofire.SessionManager
    let baseURL: URL
    let cache: FlatCache
    let decoder: JSONDecoder

    public init(baseURL: URL, configuration: URLSessionConfiguration = .default, cache: FlatCache = FlatCache(), decoder: JSONDecoder = JSONDecoder()) {
        self.baseURL = baseURL
        self.cache = cache
        self.decoder = decoder
        decoder.cache = cache
        configuration.httpAdditionalHeaders?[APIConstants.accept] = APIConstants.applicationJSON
        manager = SessionManager(configuration: configuration)
    }
}

// MARK: - JSON
extension APIClient {

    /**
     *For ResponseType: Empty Payload*

     Perform request and optionally unwrap an error

     - Parameters:
     - endpoint: An `APIEndpoint` with an associated `ResponseType` conforming to `Decodable`
     - completion: A closure to process the API response
     - error: a server or serialization error

     - Returns: a `DataRequest`
     */
    @discardableResult
    func request<Endpoint: APIEndpoint>(_ endpoint: Endpoint, completion: @escaping (_ error: Error?) -> Void) -> RequestProtocol where Endpoint.ResponseType == Payload.Empty {
        return manager.request(baseURL, endpoint: endpoint, decoder: decoder) { error in
            completion(error)
        }
    }

    /**
     *For ResponseType: Decodable*

     Perform request and serialize the response automatically according to your Response Type's `Decodable` conformance

     - Parameters:
     - endpoint: An `APIEndpoint` with an associated `ResponseType` conforming to `Decodable`
     - completion: A closure to process the API response
     - object: the decoded response object
     - error: a server or serialization error

     - Returns: a `DataRequest`
     */
    @discardableResult
    func request<Endpoint: APIEndpoint>(_ endpoint: Endpoint, completion: @escaping (_ object: Endpoint.ResponseType?, _ error: Error?) -> Void) -> RequestProtocol where Endpoint.ResponseType: Decodable {
        return manager.request(baseURL, endpoint: endpoint, decoder: decoder) { (obj, error) in
            completion(obj, error)
        }
    }

}
