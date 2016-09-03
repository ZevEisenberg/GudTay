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
    private(set) var forecastIndices = IndexSet()

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
                    let (fields, forecastIndices) = WeatherViewModel.processForecast(forecast: forecast)
                    self.fields = fields
                    self.forecastIndices = forecastIndices
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

    static func processForecast(forecast: WeatherForecast) -> (fields: [WeatherField], forecastIndices: IndexSet) {
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

        let hourlyPrecipitations = forecast.hourly.precipitation
        let hoursWeCareAbout = WeatherViewModel.desiredDryInterval(for: current.precipitation.timestamp)
        let precipitationsWeCareAbout = hourlyPrecipitations.data.filter { precipitation in
            hoursWeCareAbout.contains(precipitation.timestamp)
        }

        if precipitationsWeCareAbout.contains(where: { precipitation in
            return precipitation.probability > 0.15 || precipitation.intensity >= 0.1
        }) {
            fields.append(.needUmbrella)
        }

        // Hourly Forecast

        let hourlyMeteorologies = forecast.hourly.meteorology
        let hourlyTemperatures = forecast.hourly.temperature

        var forecastIndices = IndexSet()
        for index in 0..<24 {
            guard
                let precipitation = hourlyPrecipitations.data[safe: index],
                let temperature = hourlyTemperatures.data[safe: index],
                let meteorology = hourlyMeteorologies.data[safe: index] else {
                    break
            }
            forecastIndices.insert(fields.count)
            fields.append(.hour(time: precipitation.timestamp, icon: meteorology.icon, temp: temperature.current, precipProbability: precipitation.probability))
        }

        return (fields: fields, forecastIndices: forecastIndices)
    }

}

extension WeatherViewModel {

    static func desiredDryInterval(for date: Date, calendar: Calendar = Calendar.current) -> DateInterval {
        let components: Set<Calendar.Component> = [
            .year,
            .month,
            .day,
            ]
        let currentComponents = calendar.dateComponents(components, from: date)
        let startComponents: DateComponents = {
            var comps = currentComponents
            comps.hour = 7
            return comps
        }()

        let endComponents: DateComponents = {
            var comps = currentComponents
            comps.hour = 23
            return comps
        }()

        let startDate = calendar.date(from: startComponents)!
        let endDate = calendar.date(from: endComponents)!
        return DateInterval(start: startDate, end: endDate)
    }

}
