//
//  MBTAEndpoint.swift
//  Services
//
//  Created by Zev Eisenberg on 4/16/18.
//

import Foundation

enum MBTAEndpoint {

    struct PredictionsByStop: APIEndpoint {
        typealias ResponseType = PredictionDocument
        let path = "/predictions"
        let method = "GET"
        let stop: Tagged<Stop, String>

        var queryItems: [URLQueryItem]? {
            [
                URLQueryItem(name: "api_key", value: "1b8ef1c876f24cc39c7973f78f5bafd8"),
                URLQueryItem(name: "include", value: [APIStop.jsonType, APIRoute.jsonType, APITrip.jsonType].joined(separator: ",")),
                URLQueryItem(name: "stop", value: stop.rawValue),
            ]
        }
    }

}
