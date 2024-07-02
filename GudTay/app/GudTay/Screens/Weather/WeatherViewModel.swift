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
import WeatherKit

final class WeatherViewModel {

    enum WeatherField {

        case temperatures(current: Measurement<UnitTemperature>, high: Measurement<UnitTemperature>, low: Measurement<UnitTemperature>)
        case currentIcon(UIImage)
        case clothing(temp: Measurement<UnitTemperature>, needUmbrella: Bool)
        case hour(time: Date, icon: UIImage?, temp: Measurement<UnitTemperature>, precipProbability: Double?)

    }

    private(set) var fields: [WeatherField] = []
    private(set) var forecastBackgroundViewModel: ForecastBackgroundViewModel?

    init() {}

    struct WeatherResults {
        var current: CurrentWeather
        var hourly: Forecast<HourWeather>
        var daily: Forecast<DayWeather>
    }

    func weatherRefresh(referenceDate: Date, calendar: Calendar) async throws -> (fields: [WeatherField], background: ForecastBackgroundViewModel?) {
        let forecast = try await GudTayWeatherService.forecast()
        let results = WeatherResults(current: forecast.current, hourly: forecast.hourly, daily: forecast.daily)
        let (fields, forecastBackgroundViewModel) = WeatherViewModel.processResults(results, referenceDate: referenceDate, calendar: calendar)
        self.fields = fields
        self.forecastBackgroundViewModel = forecastBackgroundViewModel
        return (fields: fields, background: forecastBackgroundViewModel)
    }

}

private extension WeatherViewModel {

    static func processResults(_ results: WeatherResults, referenceDate: Date, calendar: Calendar) -> ([WeatherField], ForecastBackgroundViewModel?) {
        var fields = [WeatherField]()

        let current = results.current

        // Temperatures

        if let today = results.daily.first(where: { calendar.isDate($0.date, inSameDayAs: referenceDate) }) {
            fields.append(
                .temperatures(
                    current: current.temperature,
                    high: today.highTemperature,
                    low: today.lowTemperature
                )
            )
        }

        // Current Icon

        let icon = current.condition.icon(isDaylight: current.isDaylight)
        fields.append(.currentIcon(icon))

        // Clothing/umbrella
        fields.append(WeatherViewModel.clothingField(forForecast: results, referenceDate: referenceDate, calendar: calendar))

        // Hourly Forecast

        let hourlyPrecipitationTimestamps = results.hourly.map(\.date)

        let hoursUntilSameTimeNextDay = (hourlyPrecipitationTimestamps.first ?? referenceDate).hoursUntilSameTimeNextDay()

        for index in 0..<hoursUntilSameTimeNextDay {
            guard let hourly = results.hourly[checked: index] else { break }

            fields.append(
                .hour(
                    time: hourly.date,
                    icon: hourly.condition.smallIcon(isDaylight: hourly.isDaylight),
                    temp: hourly.temperature,
                    precipProbability: hourly.precipitationChance
                )
            )
        }

        var backgroundViewModel: ForecastBackgroundViewModel?
        let daysToExpand = 1
        if let firstTime = results.hourly.first?.date,
            let lastTime = results.hourly[checked: (hoursUntilSameTimeNextDay - 1)]?.date {

            // Expand the interval by ±1 day in order to be able to draw the edges of the sun interval.
            // Unfortunately, the API does not return data in the past when asking for predictions (and
            // really, who can blame them). Instead of making a relatively costly second request for
            // historical data, when we really just need a value that's close enough, the
            // ForecastBackgroundViewModel will artificially expand the range. The point of this comment is
            // just to say that this code should not be surprised if the first solar event is after today's
            // midnight, because ForecastBackgroundViewModel will work around it.
            guard let adjustedFirstTime = calendar.date(byAdding: .day, value: -daysToExpand, to: firstTime),
                let adjustedLastTime = calendar.date(byAdding: .day, value: daysToExpand, to: lastTime) else {
                    preconditionFailure("Should always be able to add and subtract a day from a date. Failed with dates \(firstTime) and \(lastTime), shifting by \(daysToExpand) day(s)")
            }

            let interval = DateInterval(start: firstTime, end: lastTime)
            let expandedInterval = DateInterval(start: adjustedFirstTime, end: adjustedLastTime)

            let events = results.daily.flatMap { daily -> [SolarEvent] in
                guard let rise = daily.sun.sunrise, let set = daily.sun.sunset else {
                    return []
                }

                let sunrise = SolarEvent(kind: .sunrise, date: rise)
                let sunset = SolarEvent(kind: .sunset, date: set)
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

    static func clothingField(
        forForecast forecast: WeatherResults,
        referenceDate: Date,
        calendar: Calendar
    ) -> WeatherField {
        let hoursWeCareAbout = WeatherViewModel.interestingHourlyInterval(for: forecast.current.date, calendar: calendar)

        let tempForClothing: Measurement<UnitTemperature>
        let needUmbrella: Bool

        let precipitationWantsUmbrella = { (precip: Double) in
            precip >= 0.1
        }

        if let hoursWeCareAbout = hoursWeCareAbout {
            let timesAndTemps = forecast.hourly.map { (time: $0.date, temp: $0.temperature) }
            let relevantTimesAndTemps = timesAndTemps
                .filter { hoursWeCareAbout.contains($0.time) }
            assert(!relevantTimesAndTemps.isEmpty)
            if let minimumTempForRange = relevantTimesAndTemps.map(\.temp).min() {
                tempForClothing = minimumTempForRange
            }
            else {
                assertionFailure("There has to be a minimum temp")
                tempForClothing = Measurement(value: 0, unit: .kelvin)
            }

            let precipitationsWeCareAbout = forecast
                .hourly
                .map { (rain: $0.precipitationChance, timestamp: $0.date) }
                .filter { hoursWeCareAbout.contains($0.timestamp) }
            needUmbrella = precipitationsWeCareAbout
                .map(\.rain)
                .contains(where: precipitationWantsUmbrella)
        }
        else {
            tempForClothing = forecast.current.temperature
            needUmbrella = forecast.hourly.contains(where: \.condition.wantsUmbrella)
        }

        return .clothing(
            temp: tempForClothing,
            needUmbrella: needUmbrella
        )
    }

}

extension WeatherCondition {
    var wantsUmbrella: Bool {
        switch self {
        case .blizzard: false
        case .blowingDust: false
        case .blowingSnow: false
        case .breezy: false
        case .clear: false
        case .cloudy: false
        case .drizzle: true
        case .flurries: false
        case .foggy: false
        case .freezingDrizzle: true
        case .freezingRain: true
        case .frigid: false
        case .hail: true
        case .haze: false
        case .heavyRain: true
        case .heavySnow: false
        case .hot: false
        case .hurricane: true
        case .isolatedThunderstorms: true
        case .mostlyClear: false
        case .mostlyCloudy: false
        case .partlyCloudy: false
        case .rain: true
        case .scatteredThunderstorms: true
        case .sleet: true
        case .smoky: false
        case .snow: false
        case .strongStorms: true
        case .sunFlurries: false
        case .sunShowers: true
        case .thunderstorms: true
        case .tropicalStorm: true
        case .windy: false
        case .wintryMix: true
        @unknown default: false
        }
    }
}
