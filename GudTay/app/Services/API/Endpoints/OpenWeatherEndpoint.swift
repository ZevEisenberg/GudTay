//
//  OpenWeatherEndpoint.swift
//  Services
//
//  Created by Zev Eisenberg on 5/28/20.
//

import Foundation

enum OpenWeatherEndpoint {

    struct Forecast: APIEndpoint {
        typealias ResponseType = OpenWeatherAPI.OneCall
        let method = "GET"
        let apiKey: String
        let latitude: Double
        let longitude: Double
        var path: String {
            "/onecall"
        }

        var queryItems: [URLQueryItem]? {
            [
                URLQueryItem(name: "lat", value: String(latitude)),
                URLQueryItem(name: "lon", value: String(longitude)),
                URLQueryItem(name: "exclude", value: "minutely,daily"),
                URLQueryItem(name: "appid", value: apiKey),
            ]
        }
    }
}
