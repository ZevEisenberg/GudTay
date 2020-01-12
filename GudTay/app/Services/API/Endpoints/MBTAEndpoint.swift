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
            [
                ("api_key", "1b8ef1c876f24cc39c7973f78f5bafd8"),
                ("include", [Stop.apiType, Route.apiType, Trip.apiType].joined(separator: ",")),
                ("stop", stop.value),
            ]
        }
    }

}
