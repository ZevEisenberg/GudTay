//
//  WeatherProtocols.swift
//  Gud Tay
//
//  Created by Zev Eisenberg on 8/14/16.
//  Copyright © 2016 Zev Eisenberg. All rights reserved.
//

protocol PrecipitationHaver {

    var precipitation: WeatherBucket<Precipitation> { get }

}

protocol MeteorologyHaver {

    var meteorology: WeatherBucket<Meteorology> { get }

}

protocol TemperatureHaver {

    var temperature: WeatherBucket<Temperature> { get }

}

protocol NearestStormHaver {

    var nearestStorm: WeatherBucket<NearestStorm> { get }

}

protocol AlmanacHaver {

    var almanac: WeatherBucket<Almanac> { get }

}
