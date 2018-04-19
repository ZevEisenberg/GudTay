//
//  APIEndpoint+Logging.swift
//  GudTay
//
//  Created by ZevEisenberg on 7/24/17.
//
//

import Alamofire
import Swiftilities

public class NetworkLog: Log {}

public protocol NetworkLoggable {

    var logLevel: Log.Level { get }

}

extension NetworkLoggable {

    public var logLevel: Log.Level {
        #if DEBUG
            return .verbose
        #else
            return .warn
        #endif
    }

}

extension APIEndpoint {

    func log(_ apiData: Data) {
        guard logLevel.rawValue <= Log.Level.verbose.rawValue else { return }

        if let jsonObject = try? JSONSerialization.jsonObject(with: apiData, options: []),
            let reserialized = try? JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted, .sortedKeys]),
            let string = String(data: reserialized, encoding: .utf8) {
            log(string)
        }
        else if let string = String(data: apiData, encoding: .utf8) {
            log(string)
        }
        else {
            log("Failed to decode data: \(apiData)")
        }
    }

    func log(_ request: DataRequest) {
        log(request.debugDescription)
    }

    func log(_ any: Any) {
        switch logLevel {
        case .verbose: NetworkLog.verbose(any)
        case .debug: NetworkLog.debug(any)
        case .info: NetworkLog.info(any)
        case .warn: NetworkLog.warn(any)
        case .error: NetworkLog.error(any)
        case .off: break
        }
    }

}
