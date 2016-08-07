//
//  MBTAViewModel.swift
//  Gud Tay
//
//  Created by Zev Eisenberg on 7/25/16.
//  Copyright © 2016 Zev Eisenberg. All rights reserved.
//

import Foundation

final class MBTAViewModel {

    enum UpcomingTrips {

        case two(next: TimeInterval, later: TimeInterval)
        case one(next: TimeInterval)
        case none

    }

    typealias RouteDescription = (routeType: ModeType, routeId: String, directionId: String)

    enum Result {

        case success([UpcomingTrips])
        case failure(MBTAViewModel.RefreshError)

    }

    enum RefreshError: Error {

        case jsonWasNil
        case networkError(NSError)
        case jsonError(JSONError)
        case genericError(Error)

    }

    private let serviceType: MBTAServiceType.Type

    init(serviceType: MBTAServiceType.Type) {
        self.serviceType = serviceType
    }

    func refresh(completion: (Result) -> ()) {
        self.serviceType.predictionsByStop(stopId: "place-sull") { apiResult in
            switch apiResult {
            case .success(let jsonObject):
                guard let jsons = jsonObject else {
                    completion(.failure(.jsonWasNil))
                    return
                }

                do {
                    let sullivan = try Stop(json: jsons)
                    let upcomingTrips = MBTAViewModel.upcomingTrips(from: sullivan)
                    completion(.success(upcomingTrips))
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

private extension MBTAViewModel {

    static func upcomingTrips(from stop: Stop) -> [UpcomingTrips] {

        let routeDescriptions = [
            (routeType: ModeType.subway, routeId: "Orange", directionId: "0"),
            (routeType: ModeType.bus, routeId: "747", directionId: "1"),
            (routeType: ModeType.bus, routeId: "86", directionId: "1"),
            (routeType: ModeType.bus, routeId: "90", directionId: "1"),
            (routeType: ModeType.bus, routeId: "91", directionId: "1"),
            ]

        return routeDescriptions.map { description in
            return upcomingTrips(fromStop: stop, routeDescription: description)
        }

    }

    static func upcomingTrips(fromStop stop: Stop, routeDescription: RouteDescription) -> UpcomingTrips {

        let (routeType, routeId, directionId) = routeDescription

        let trips = stop.modes
            .filter { mode in mode.type == routeType }
            .flatMap { mode in mode.routes }
            .filter { route in route.identifier == routeId }
            .flatMap { route in route.directions }
            .filter { direction in direction.identifier == directionId }
            .flatMap { direction in direction.trips }

        guard !trips.isEmpty else {
            return .none
        }

        let first = trips[safe: 0]
        let second = trips[safe: 1]

        let upcomingTrips: UpcomingTrips

        switch (first, second) {
        case (.some(let first), .some(let second)):
            upcomingTrips = .two(next: first.predictedSecondsAway, later: second.predictedSecondsAway)
        case (.some(let first), .none):
            upcomingTrips = .one(next: first.predictedSecondsAway)
        case(.none, .some):
            preconditionFailure("This shouldn't be possible")
        case (.none, .none):
            upcomingTrips = .none
        }

        return upcomingTrips
    }
}

extension MBTAViewModel.UpcomingTrips: Equatable {

    static func == (lhs: MBTAViewModel.UpcomingTrips, rhs: MBTAViewModel.UpcomingTrips) -> Bool {
        switch (lhs, rhs) {
        case (.two(let aNext, let aLater), .two(let bNext, let bLater)):
            return aNext == bNext && aLater == bLater
        case (.one(let aNext), .one(let bNext)):
            return aNext == bNext
        case (.none, .none):
            return true
        default:
            return false
        }
    }

}
