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

    enum Result {

        case success(JSONObject?)
        case failure(NSError)

    }

    static func get(baseUrl: URL, path: String, params: Dictionary<String, AnyObject>? = nil, completion: (Result) -> ()) {
        let params = params ?? [:]
        let request = clientURLRequest(baseUrl: baseUrl, path: path, params: params)
        dataTask(request, method: "GET", completion: completion)
    }

}

private extension APIClient {

    static func dataTask(_ request: NSMutableURLRequest, method: String, completion: (Result) -> ()) {
        request.httpMethod = method

        let session = URLSession(configuration: URLSessionConfiguration.default)

        session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in

            if let data = data {
                if let string = String(data: data, encoding: .utf8) {
                    BuddyBuildSDK.setCrashMetadataObject(string, forKey: "originalResponse")
                }
                else {
                    BuddyBuildSDK.setCrashMetadataObject(data, forKey: "originalResponseThatCouldNotBeConvertedToAString")
                }
                let json = try? JSONSerialization.jsonObject(with: data, options: [])
                if let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode {
                    DispatchQueue.main.async {
                        completion(.success(json as? JSONObject))
                    }
                }
                else {
                    var error = error ?? NSError.my_genericError()
                    if let response = response as? HTTPURLResponse {
                        error = NSError.my_httpError(response: response)
                    }
                    DispatchQueue.main.async {
                        BuddyBuildSDK.setCrashMetadataObject(error, forKey: "httpResponseError")
                        completion(.failure(error))
                    }
                }
            }
            else {
                DispatchQueue.main.async {
                    let error = error ?? NSError.my_genericError()
                    BuddyBuildSDK.setCrashMetadataObject(error, forKey: "httpResponseError")
                    completion(.failure(error))
                }
            }
            }.resume()
    }

    static func clientURLRequest(baseUrl: URL, path: String, params: Dictionary<String, AnyObject>) -> NSMutableURLRequest {
        guard let urlWithPath = try? baseUrl.appendingPathComponent(path) else {
            preconditionFailure()
        }
        var paramPairs = [String]()
        for (key, value) in params {
            if let escapedKey = key.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed),
                let escapedValue = value.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) {
                paramPairs.append("\(escapedKey)=\(escapedValue)")
            }
            else {
                preconditionFailure("unable to escape either key: '\(key)' or value: \(value)")
            }
        }

        var urlComponents = URLComponents(url: urlWithPath, resolvingAgainstBaseURL: false)
        urlComponents?.percentEncodedQuery = paramPairs.joined(separator: "&")
        let fullUrl = urlComponents?.url!

        let request = NSMutableURLRequest(url: fullUrl!)

        return request
    }

}

private extension NSError {

    @nonobjc static let myDomain = "com.zeveisenberg.gudtay"

    class func my_genericError() -> NSError {
        return NSError(domain: NSError.myDomain, code: -1, userInfo: [
            NSLocalizedDescriptionKey: "An unknown error occurred."
            ])
    }

    class func my_httpError(response: HTTPURLResponse) -> NSError {
        return NSError(domain: NSError.myDomain, code: response.statusCode, userInfo: [
            NSLocalizedDescriptionKey: "Got back HTTP code \(response.statusCode) from request to URL \(response.url)."
            ])
    }

}
