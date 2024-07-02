//
//  APIEndpoint+Logging.swift
//  GudTay
//
//  Created by ZevEisenberg on 7/24/17.
//
//

import Swiftilities

public class NetworkLog: Log {}

public protocol NetworkLoggable {

    var logLevel: Log.Level { get }

}

public extension NetworkLoggable {

    var logLevel: Log.Level {
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
            let reserialized = try? JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted, .sortedKeys]) {
            let string = String(decoding: reserialized, as: UTF8.self)
            log(string)
        }
        else {
            let string = String(decoding: apiData, as: UTF8.self)
            log(string)
        }
    }

    func log(_ request: URLRequest) {
        log(request.description)
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
