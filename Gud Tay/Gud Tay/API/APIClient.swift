//
//  APIClient.swift
//  Gud Tay
//
//  Created by Zev Eisenberg on 7/14/16.
//
//

import Foundation

// APIClient design inspired by https://thatthinginswift.com/write-your-own-api-clients-swift/

enum APIClient {

    enum Result<T> {

        case success(T)
        case failure(Error)

    }

    static func getJson<Value: Decodable>(baseUrl: URL, path: String, params: [String: Any]? = nil, completion: @escaping (Result<Value>) -> Void) {
        let params = params ?? [:]
        let request = clientURLRequest(baseUrl: baseUrl, path: path, params: params)
        jsonDataTask(request, method: "GET", completion: completion)
    }

}

private extension APIClient {

    static func jsonDataTask<Value: Decodable>(_ request: NSMutableURLRequest, method: String, completion: @escaping (Result<Value>) -> Void) {
        request.httpMethod = method

        let session = URLSession(configuration: URLSessionConfiguration.default)

        session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in

            if let data = data {
                if let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode {
                    do {
                        let decoded = try JSONDecoder().decode(Value.self, from: data)
                        DispatchQueue.main.async {
                            completion(.success(decoded))
                        }
                    }
                    catch {
                        DispatchQueue.main.async {
                            completion(.failure(error))
                        }
                    }
                }
                else {
                    var error = error ?? NSError.my_genericError()
                    if let response = response as? HTTPURLResponse {
                        error = NSError.my_httpError(response: response)
                    }
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
            else {
                DispatchQueue.main.async {
                    let error = error ?? NSError.my_genericError()
                    completion(.failure(error))
                }
            }
            }.resume()
    }

    static func clientURLRequest(baseUrl: URL, path: String, params: [String: Any]) -> NSMutableURLRequest {
        var paramPairs = [String]()
        for (key, value) in params {
            if let escapedKey = key.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed),
                let escapedValue = (value as? String)?.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) {
                paramPairs.append("\(escapedKey)=\(escapedValue)")
            }
            else {
                preconditionFailure("unable to escape either key: '\(key)' or value: \(value)")
            }
        }

        var urlComponents = URLComponents(url: baseUrl.appendingPathComponent(path), resolvingAgainstBaseURL: false)
        urlComponents?.percentEncodedQuery = paramPairs.joined(separator: "&")
        let fullUrl = urlComponents?.url!

        let request = NSMutableURLRequest(url: fullUrl!)
        request.timeoutInterval = 10.0

        return request
    }

}

private extension NSError {

    @nonobjc static let myDomain = "com.zeveisenberg.gudtay"

    class func my_genericError() -> NSError {
        return NSError(domain: NSError.myDomain, code: -1, userInfo: [
            NSLocalizedDescriptionKey: "An unknown error occurred.",
            ])
    }

    class func my_httpError(response: HTTPURLResponse) -> NSError {
        return NSError(domain: NSError.myDomain, code: response.statusCode, userInfo: [
            NSLocalizedDescriptionKey: "Got back HTTP code \(response.statusCode) from request to URL: \(response.url.flatMap(String.init(describing:)) ?? "nil").",
            ])
    }

}
