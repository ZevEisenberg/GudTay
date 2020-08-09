//
//  MBTAViewModel.swift
//  GudTay
//
//  Created by Zev Eisenberg on 7/25/16.
//  Copyright © 2016 Zev Eisenberg. All rights reserved.
//

import Foundation
import Services
import UIKit.UIImage
import Utilities

final class WeatherViewModel {

    enum WeatherField {

        case temperatures(current: Double, high: Double, low: Double)
        case currentIcon(UIImage)
        case clothing(temp: Double, needUmbrella: Bool)
        case hour(time: Date, icon: UIImage?, temp: Double, precipProbability: Double?)

    }

    private(set) var fields: [WeatherField] = []
    private(set) var forecastBackgroundViewModel: ForecastBackgroundViewModel?

    private let openWeatherService: OpenWeatherService

    init(openWeatherService: OpenWeatherService) {
        self.openWeatherService = openWeatherService
    }

    func openWeatherRefresh(referenceDate: Date, calendar: Calendar, completion: @escaping (Result<(fields: [WeatherField], background: ForecastBackgroundViewModel?), Error>) -> Void) {
        openWeatherService.forecast() { (apiResult: Result<OpenWeatherAPI.OneCall, Error>) in
            switch apiResult {
            case .success(let oneCall):
                let (fields, forecastBackgroundViewModel) = WeatherViewModel.processOpenWeatherForecast(forecast: oneCall, referenceDate: referenceDate, calendar: calendar)
                self.fields = fields
                self.forecastBackgroundViewModel = forecastBackgroundViewModel
                completion(.success((fields: self.fields, background: self.forecastBackgroundViewModel)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

}

private extension WeatherViewModel {

    static func processOpenWeatherForecast(forecast: OpenWeatherAPI.OneCall, referenceDate: Date, calendar: Calendar) -> ([WeatherField], ForecastBackgroundViewModel?) {
        var fields = [WeatherField]()

        let current = forecast.current

        // Temperatures

        if let today = forecast.daily.first(where: { calendar.isDate($0.date, inSameDayAs: referenceDate) }) {
            fields.append(.temperatures(
                current: current.temp,
                high: today.temp.max,
                low: today.temp.min))
        }

        // Current Icon

        if let icon = current.weather.first?.icon.image {
            fields.append(.currentIcon(icon))
        }

        // Clothing/umbrella
        fields.append(WeatherViewModel.openWeatherClothingField(forForecast: forecast, referenceDate: referenceDate, calendar: calendar))

        // Hourly Forecast

        let hourlyPrecipitations = forecast
            .hourly
            .compactMap { hourly in
                hourly.rain.map { rain in (timestamp: hourly.date, rain: rain) }}

        let hoursUntilSameTimeNextDay = (hourlyPrecipitations.first?.timestamp ?? referenceDate).hoursUntilSameTimeNextDay()

        for index in 0..<hoursUntilSameTimeNextDay {
            guard let hourly = forecast.hourly[checked: index] else { break }

            fields.append(.hour(
                time: hourly.date,
                icon: hourly.weather.first?.icon.smallImage,
                temp: hourly.temp,
                precipProbability: hourly.rain?.oneHour ?? 0)
            )
        }

        var backgroundViewModel: ForecastBackgroundViewModel?
        let daysToExpand = 1
        if let firstTime = forecast.hourly.first?.date,
            let lastTime = forecast.hourly[checked: (hoursUntilSameTimeNextDay - 1)]?.date {

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

            let events = forecast.daily.flatMap { daily -> [SolarEvent] in
                let sunrise = SolarEvent(kind: .sunrise, date: daily.sunrise)
                let sunset = SolarEvent(kind: .sunset, date: daily.sunset)
                return [sunrise, sunset]
            }.compactMap { event in
                expandedInterval.contains(event.date) ? event : nil
            }.sorted(by: \.date)

            backgroundViewModel = ForecastBackgroundViewModel(
                interval: interval, // original interval, for purposes of scaling in the UI
                solarEvents: events
            )
        }

        return (fields, backgroundViewModel)
    }

}

extension WeatherViewModel {

    /// Given a date representing the current time,
    /// gives us the interval that is interesting for
    /// determining what to wear and what to bring
    /// in order to be comfortable with the weather.
    /// If we're inside the normal daily range, ignore
    /// time that has already passed (i.e. the returned range
    /// will start at the current date). Otherwise, return nil,
    /// signifying that we are outside the range and should
    /// just use the current date
    static func interestingHourlyInterval(for date: Date, calendar: Calendar) -> DateInterval? {
        let components: Set<Calendar.Component> = [
            .year,
            .month,
            .day,
            .hour,
            .timeZone,
            ]
        let currentComponents = calendar.dateComponents(components, from: date)

        let startComponents = with(currentComponents) {
            $0.hour = 7
            $0.minute = 0
        }

        let endComponents = with(currentComponents) {
            $0.hour = 23
            $0.minute = 0
        }

        let startDate = calendar.date(from: startComponents)!
        let endDate = calendar.date(from: endComponents)!

        guard startDate < endDate else { return nil }

        let fullInterestingInterval = DateInterval(start: startDate, end: endDate)
        guard
            fullInterestingInterval.contains(date)
            else { return nil } // ignore interval, because we are not inside it

        let adjustedInterval = DateInterval(start: date, end: endDate)
        return adjustedInterval
    }

    private static func openWeatherClothingField(
        forForecast forecast: OpenWeatherAPI.OneCall,
        referenceDate: Date,
        calendar: Calendar) -> WeatherField {
        let hoursWeCareAbout = WeatherViewModel.interestingHourlyInterval(for: forecast.current.date, calendar: calendar)

        let tempForClothing: Double
        let needUmbrella: Bool

        let precipitationWantsUmbrella = { (precip: OpenWeatherAPI.Rain) in
            precip.oneHour > 0.15 || precip.oneHour >= 0.1
        }

        if let hoursWeCareAbout = hoursWeCareAbout {
            let timesAndTemps = forecast.hourly.map { (time: $0.date, temp: $0.temp) }
            let relevantTimesAndTemps = timesAndTemps
                .filter { hoursWeCareAbout.contains($0.time) }
            assert(!relevantTimesAndTemps.isEmpty)
            if let minimumTempForRange = relevantTimesAndTemps.map(\.temp).min() {
                tempForClothing = minimumTempForRange
            }
            else {
                assertionFailure("There has to be a minimum temp")
                tempForClothing = 0
            }

            let precipitationsWeCareAbout = forecast
                .hourly
                .map { (rain: $0.rain, timestamp: $0.date) }
                .filter { hoursWeCareAbout.contains($0.timestamp) }
            needUmbrella = precipitationsWeCareAbout
                .compactMap(\.rain)
                .contains(where: precipitationWantsUmbrella)
        }
        else {
            tempForClothing = forecast.current.temp
            needUmbrella = forecast.current.weather.contains(where: \.wantsUmbrella)
        }

        return .clothing(
            temp: tempForClothing,
            needUmbrella: needUmbrella
        )
    }

}
