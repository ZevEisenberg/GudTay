//
//  WeatherEndpoint.swift
//  Services
//
//  Created by Zev Eisenberg on 4/18/18.
//

enum WeatherEndpoint {

    struct Forecast: APIEndpoint {
        typealias ResponseType = WeatherForecast
        let apiKey: String
        let latitude: Double
        let longitude: Double
        var path: String {
            "/forecast/\(apiKey)/\(latitude),\(longitude)"
        }
        let method = "GET"
    }

}
