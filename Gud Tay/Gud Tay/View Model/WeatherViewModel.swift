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

        case success(WeatherForecast)
        case failure(ViewModel.RefreshError)

    }

    private let serviceType: WeatherServiceType.Type

    init(serviceType: WeatherServiceType.Type) {
        self.serviceType = serviceType
    }

    func refresh(completion: (Result) -> ()) {
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
                    completion(.success(forecast))
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
        // self.serviceType.predictionsByStop(stopId: "place-sull") { apiResult in
        //     switch apiResult {
        //     case .success(let jsonObject):
        //         guard let jsons = jsonObject else {
        //             completion(.failure(.jsonWasNil))
        //             return
        //         }
        //
        //         do {
        //             let sullivan = try Stop(json: jsons)
        //             let upcomingTrips = MBTAViewModel.upcomingTrips(from: sullivan)
        //             completion(.success(upcomingTrips))
        //         }
        //         catch let jsonError as JSONError {
        //             completion(.failure(.jsonError(jsonError)))
        //         }
        //         catch let genericError {
        //             completion(.failure(.genericError(genericError)))
        //         }
        //     case .failure(let networkError):
        //         completion(.failure(.networkError(networkError)))
        //     }
        // }
    }

}

private extension WeatherViewModel {

}
