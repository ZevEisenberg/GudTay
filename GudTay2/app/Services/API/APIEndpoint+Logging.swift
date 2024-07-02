//
//  APIEndpoint+Logging.swift
//  GudTay
//
//  Created by ZevEisenberg on 7/24/17.
//
//

import Alamofire
import Marshal
import Swiftilities

public class NetworkLog: Log {}

public protocol NetworkLoggable {

    var logLevel: Log.Level { get }

}

extension NetworkLoggable {

    public var logLevel: Log.Level {
        return .verbose
    }

}

extension APIEndpoint {

    func log(_ jsonArray: [JSONObject]) {
        log(jsonArray.debugDescription)
    }

    func log(_ json: JSONObject) {
        log(json.debugDescription)
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
