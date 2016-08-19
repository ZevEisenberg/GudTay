//
//  MBTAViewModel.swift
//  Gud Tay
//
//  Created by Zev Eisenberg on 7/25/16.
//  Copyright © 2016 Zev Eisenberg. All rights reserved.
//

import Foundation

final class WeatherViewModel {

    enum Result {

        case success([WeatherField])
        case failure(ViewModel.RefreshError)

    }

    enum WeatherField {

        case temperatures(current: Double, high: Double, low: Double)
        case currentIcon(Icon)
        case needUmbrella
        case hour(time: Date, icon: Icon?, temp: Double, precipProbability: Double?)

    }

    private(set) var fields: [WeatherField] = []

    private let serviceType: WeatherServiceType.Type

    init(serviceType: WeatherServiceType.Type) {
        self.serviceType = serviceType
    }

    func refresh(completion: @escaping (Result) -> ()) {
        // n.b. lat/long have been rebased to be the center of Boston instead of my real old address for privacy reasons.
        self.serviceType.predictions(latitude: 42.3601, longitude: -71.0589) { apiResult in
            switch apiResult {
            case .success(let jsonObject):
                guard let jsonObject = jsonObject else {
                    completion(.failure(.jsonWasNil))
                    return
                }

                do {
                    let forecast = try WeatherForecast(json: jsonObject)
                    self.fields = WeatherViewModel.processForecast(forecast: forecast)
                    completion(.success(self.fields))
                }
                catch let jsonError as JSONError {
                    completion(.failure(.jsonError(jsonError)))
                }
                catch let genericError {
                    completion(.failure(.genericError(genericError)))
                }
            case .failure(let networkError):
                completion(.failure(.networkError(networkError)))
            }
        }
    }

}

private extension WeatherViewModel {

    static func processForecast(forecast: WeatherForecast) -> [WeatherField] {
        var fields = [WeatherField]()

        let current = forecast.currently

        // Temperatures

        if let today = forecast.daily.almanac.data.first {
            fields.append(.temperatures(
                current: current.temperature.current,
                high: today.temperatureRange.max,
                low: today.temperatureRange.min))
        }

        // Current Icon

        if let icon = current.meteorology.icon {
            fields.append(.currentIcon(icon))
        }

        // Need an umbrella?

        if let today = forecast.daily.almanac.data.first {
            if today.precipitation.probability > 0.15 || today.precipitation.intensity >= 0.1 {
                fields.append(.needUmbrella)
            }
        }

        // Hourly Forecast

        let hourlyPrecipitation = forecast.hourly.precipitation
        let hourlyMeteorology = forecast.hourly.meteorology
        let hourlyTemperature = forecast.hourly.temperature

        for index in 0..<24 {
            guard
                let precipitation = hourlyPrecipitation.data[safe: index],
                let temperature = hourlyTemperature.data[safe: index] else {
                    break
            }

            fields.append(.hour(time: precipitation.timestamp, icon: hourlyMeteorology.icon, temp: temperature.current, precipProbability: precipitation.probability))
        }

        return fields
    }

}
