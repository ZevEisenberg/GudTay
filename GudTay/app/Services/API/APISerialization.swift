///
//  APISerialization.swift
//  GudTay
//
//  Created by ZevEisenberg on 4/16/17.
//
//

import Alamofire

private func ResponseSerializer<T>(decoder: JSONDecoder, serializer: @escaping (Data) throws -> T) -> DataResponseSerializer<T> {
    DataResponseSerializer { _, _, data, error in
        do {
            if let error = error { throw error }
            guard let validData = data else {
                throw APIError.invalidResponse
            }
            return .success(try serializer(validData))
        }
        catch {
            if let validData = data, let errorDocument = try? decoder.decode(JSONAPI.Errors.self, from: validData),
                let firstError = errorDocument.errors.first {
                return .failure(firstError)
            }
            else {
                return .failure(error as NSError)
            }
        }
    }
}

func APIObjectResponseSerializer<Endpoint: APIEndpoint>(_ endpoint: Endpoint, decoder: JSONDecoder) -> DataResponseSerializer<Void> where Endpoint.ResponseType == Payload.Empty {
    ResponseSerializer(decoder: decoder) { data in
        endpoint.log(data)
    }
}

/// Response serializer to import JSON Object using JSONDecoder and return an object
func APIObjectResponseSerializer<Endpoint: APIEndpoint>(_ endpoint: Endpoint, decoder: JSONDecoder) -> DataResponseSerializer<Endpoint.ResponseType> where Endpoint.ResponseType: Decodable {
    ResponseSerializer(decoder: decoder) { data in
        endpoint.log(data)
        if let cache = decoder.cache {
            return try cache.deferObserverNotifications(during: {
                try decoder.decode(Endpoint.ResponseType.self, from: data)
            })
        }
        else {
            return try decoder.decode(Endpoint.ResponseType.self, from: data)
        }
    }
}
