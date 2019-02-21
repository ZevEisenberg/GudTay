//
//  MBTAViewModel.swift
//  GudTay
//
//  Created by Zev Eisenberg on 7/25/16.
//  Copyright © 2016 Zev Eisenberg. All rights reserved.
//

import Alamofire
import Foundation
import Services

final class WeatherViewModel {

    enum Result {

        case success([WeatherField], ForecastBackgroundViewModel?)
        case failure(Error)

    }

    enum WeatherField {

        case temperatures(current: Double, high: Double, low: Double)
        case currentIcon(Icon)
        case clothing(temp: Double, needUmbrella: Bool)
        case hour(time: Date, icon: Icon?, temp: Double, precipProbability: Double?)

    }

    private(set) var fields: [WeatherField] = []
    private(set) var forecastBackgroundViewModel: ForecastBackgroundViewModel?

    private let service: WeatherServiceProtocol

    init(service: WeatherServiceProtocol) {
        self.service = service
    }

    func refresh(referenceDate: Date, calendar: Calendar, completion: @escaping (Result) -> Void) {
        service.predictions() { (apiResult: Alamofire.Result<WeatherForecast>) in
            switch apiResult {
            case .success(let forecast):
                let (fields, forecastBackgroundViewModel) = WeatherViewModel.processForecast(forecast: forecast, referenceDate: referenceDate, calendar: calendar)
                self.fields = fields
                self.forecastBackgroundViewModel = forecastBackgroundViewModel
                completion(.success(self.fields, self.forecastBackgroundViewModel))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

}

private extension WeatherViewModel {

    static func processForecast(forecast: WeatherForecast, referenceDate: Date, calendar: Calendar) -> ([WeatherField], ForecastBackgroundViewModel?) {
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

        // Clothing/umbrella
        let hourlyPrecipitations = forecast.hourly.precipitation
        fields.append(WeatherViewModel.clothingField(forForecast: forecast, currently: current, hourlyPrecipitations: hourlyPrecipitations, referenceDate: referenceDate, calendar: calendar))

        // Hourly Forecast

        let hourlyMeteorologies = forecast.hourly.meteorology
        let hourlyTemperatures = forecast.hourly.temperature

        let hoursUntilSameTimeNextDay = (hourlyPrecipitations.data[checked: 0]?.timestamp ?? referenceDate).hoursUntilSameTimeNextDay()

        for index in 0..<hoursUntilSameTimeNextDay {
            guard
                let precipitation = hourlyPrecipitations.data[checked: index],
                let temperature = hourlyTemperatures.data[checked: index],
                let meteorology = hourlyMeteorologies.data[checked: index] else {
                    break
            }

            fields.append(.hour(time: precipitation.timestamp, icon: meteorology.icon, temp: temperature.current, precipProbability: precipitation.probability))
        }

        var backgroundViewModel: ForecastBackgroundViewModel?
        let daysToExpand = 1
        if let firstTime = hourlyPrecipitations.data[checked: 0]?.timestamp,
            let lastTime = hourlyPrecipitations.data[checked: (hoursUntilSameTimeNextDay - 1)]?.timestamp {

            // Expand the interval by ±1 day in order to be able to draw the edges of the sun interval.
            // Unfortunately, the API does not return data in the past when asking for predictions (and
            // really, who can blame them). Instead of making a relatively costly second request for
            // historical data, when we really just need a value that's close enough, the
            // ForecastBackgroundViewModel will artifically expand the range. The point of this comment is
            // just to say that this code should not be surprised if the first solar event is after today's
            // midnight, becuase ForecastBackgroundViewModel will work around it.
            guard let adjustedFirstTime = calendar.date(byAdding: .day, value: -daysToExpand, to: firstTime),
                let adjustedLastTime = calendar.date(byAdding: .day, value: daysToExpand, to: lastTime) else {
                    preconditionFailure("Should always be able to add and subtract a day from a date. Failed with dates \(firstTime) and \(lastTime), shifting by \(daysToExpand) day(s)")
            }

            let interval = DateInterval(start: firstTime, end: lastTime)
            let expandedInterval = DateInterval(start: adjustedFirstTime, end: adjustedLastTime)

            let almanacs = forecast.daily.almanac.data

            let events = almanacs.flatMap { almanac -> [SolarEvent] in
                let sunrise = SolarEvent(kind: .sunrise, date: almanac.sunriseTime)
                let sunset = SolarEvent(kind: .sunset, date: almanac.sunsetTime)
                return [sunrise, sunset]
                }.compactMap { event in
                    return expandedInterval.contains(event.date) ? event : nil
                }.sorted { $0.date < $1.date }

            backgroundViewModel = ForecastBackgroundViewModel(
                interval: interval, // original interval, for purposes of scaling in the UI
                solarEvents: events
            )
        }

        return (fields, backgroundViewModel)
    }

}

private extension WeatherViewModel {

    static func desiredDryInterval(for date: Date, calendar: Calendar) -> DateInterval {
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

    private static func clothingField(
        forForecast forecast: WeatherForecast,
        currently current: Currently,
        hourlyPrecipitations: WeatherBucket<Precipitation>,
        referenceDate: Date,
        calendar: Calendar) -> WeatherField {
        let hoursWeCareAboutForUmbrella = WeatherViewModel.desiredDryInterval(for: current.precipitation.timestamp, calendar: calendar)
        let precipitationsWeCareAbout = hourlyPrecipitations.data.filter { precipitation in
            hoursWeCareAboutForUmbrella.contains(precipitation.timestamp)
        }

        // TODO: consolidate precipitation date range with similar logic for temperature logic
        let currentHour = calendar.component(.hour, from: referenceDate)
        let eightAMHour = 8
        let elevenPMHour = 23
        let interestingTimeRangeStartHour = max(eightAMHour, currentHour)

        let tempForClothing: Double
        if  interestingTimeRangeStartHour < elevenPMHour,
            case let interestingTimeRange = interestingTimeRangeStartHour..<elevenPMHour,
            interestingTimeRange.contains(currentHour) {
            // use minimum temp for relevant range
            let timesAndTemps = zip(forecast.hourly.precipitation.data, forecast.hourly.temperature.data)
                .map { (time: $0.0.timestamp, temp: $0.1.current) }
            // TODO: use full date range comparison, not just hourly, to prevent getting morning hours from tomorrow
            let relevantTimesAndTemps = timesAndTemps
                .filter { interestingTimeRange.contains($0.time.hour(using: calendar)) }

            if let minimumTempForRange = relevantTimesAndTemps.map({ $0.temp }).min() {
                tempForClothing = minimumTempForRange
            }
            else {
                assertionFailure("There has to be a minimum temp")
                tempForClothing = 0
            }
        }
        else {
            // use current temp
            tempForClothing = current.temperature.current
        }

        let needUmbrella = precipitationsWeCareAbout.contains { $0.probability > 0.15 || $0.intensity >= 0.1 }
        return .clothing(
            temp: tempForClothing,
            needUmbrella: needUmbrella
        )
    }

}

extension Date {

    func hour(using calendar: Calendar) -> Int {
        return calendar.component(.hour, from: self)
    }

}
