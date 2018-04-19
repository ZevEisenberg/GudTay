//
//  WeatherEndpoint.swift
//  Services
//
//  Created by Zev Eisenberg on 4/18/18.
//

import Alamofire

enum WeatherEndpoint {

    struct Forecast: APIEndpoint {
        typealias ResponseType = WeatherForecast
        let apiKey: String
        let latitude: Double
        let longitude: Double
        var path: String {
            return "/forecast/\(apiKey)/\(latitude),\(longitude)"
        }
        let method: HTTPMethod = .get
    }

}
