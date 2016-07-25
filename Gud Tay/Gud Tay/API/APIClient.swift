//
//  APIClient.swift
//  Gud Tay
//
//  Created by Zev Eisenberg on 7/14/16.
//
//

import Foundation

// APIClient design inspired by https://thatthinginswift.com/write-your-own-api-clients-swift/

final class APIClient {

    enum Result {

        case success(JSONObject?)
        case failure(NSError)

    }

    func stopsNearHome(completion: (Result) -> ()) {
        let params = ["lat": Constants.lat, "lon": Constants.lon]

        get(clientURLRequest(Endpoints.stopsByLocation, params: params), completion: completion)
    }

    func predictionsByStop(stopId: String, completion: (Result) -> ()) {
        let params = ["stop": stopId]

        get(clientURLRequest(Endpoints.predictionsByStop, params: params), completion: completion)
    }

}

private extension APIClient {

    struct Constants {

        static let apiKey = "40jKQwmnXk-4slxceBfcEA"
        static let username = "ZevEisenberg"
        static let appName = "status-board-mbta"
        static let host = "http://realtime.mbta.com"
        static let commonPath = "developer/api/v2"
        static let lat = "42.385081"
        static let lon = "-71.077848"

    }

    struct Endpoints {

        static let stopsByLocation = "stopsbylocation"
        static let predictionsByStop = "predictionsbystop"

    }

    static func baseUrl() -> URL {
        let hostUrl = URL(string: Constants.host)!
        guard let commonUrl = try? hostUrl.appendingPathComponent(Constants.commonPath) else {
            preconditionFailure()
        }

        return commonUrl
    }

    func dataTask(_ request: NSMutableURLRequest, method: String, completion: (Result) -> ()) {
        request.httpMethod = method

        let session = URLSession(configuration: URLSessionConfiguration.default)

        session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in

            if let data = data {
                let json = try? JSONSerialization.jsonObject(with: data, options: [])
                if let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode {
                    completion(.success(json as? JSONObject))
                } else {
                    var error = error ?? NSError.my_genericError()
                    if let response = response as? HTTPURLResponse {
                        error = NSError.my_httpError(code: response.statusCode)
                    }
                    completion(.failure(error))
                }
            }
            }.resume()
    }

    func post(_ request: NSMutableURLRequest, completion: (Result) -> ()) {
        dataTask(request, method: "POST", completion: completion)
    }

    func put(_ request: NSMutableURLRequest, completion: (Result) -> ()) {
        dataTask(request, method: "PUT", completion: completion)
    }

    func get(_ request: NSMutableURLRequest, completion: (Result) -> ()) {
        dataTask(request, method: "GET", completion: completion)
    }

    func clientURLRequest(_ path: String, params: Dictionary<String, AnyObject>? = nil) -> NSMutableURLRequest {
        let baseUrl = APIClient.baseUrl()
        guard let urlWithPath = try? baseUrl.appendingPathComponent(path) else {
            preconditionFailure()
        }
        var mutableParams = params ?? [:]
        mutableParams["api_key"] = Constants.apiKey
        var paramPairs = [String]()
        for (key, value) in mutableParams {
            if let escapedKey = key.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed),
                let escapedValue = value.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) {
                paramPairs.append("\(escapedKey)=\(escapedValue)")
            } else {
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

extension NSError {

    @nonobjc static let myDomain = "com.zeveisenberg.gudtay"

    class func my_genericError() -> NSError {
        return NSError(domain: NSError.myDomain, code: -1, userInfo: [
            NSLocalizedDescriptionKey: "An unknown error occurred."
            ])
    }

    class func my_httpError(code: Int) -> NSError {
        return NSError(domain: NSError.myDomain, code: code, userInfo: [
            NSLocalizedDescriptionKey: "Got back HTTP error code \(code)."
            ])
    }

}
