//
//  MBTAEndpoint.swift
//  Services
//
//  Created by Zev Eisenberg on 4/16/18.
//

import Alamofire

enum MBTAEndpoint {

    struct PredictionsByStop: APIEndpoint {
        typealias ResponseType = JSONAPI.Payload<[Prediction]>
        let path = "/predictions"
        let method: HTTPMethod = .get
        let stop: Identifier<Stop>

        var queryParams: [APIEndpoint.QueryParam]? {
            return [
                ("include", [Stop.apiType, Route.apiType, Trip.apiType].joined(separator: ",")),
                ("stop", stop.value),
            ]
        }
    }

}
