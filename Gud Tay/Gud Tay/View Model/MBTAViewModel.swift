//
//  MBTAViewModel.swift
//  Gud Tay
//
//  Created by Zev Eisenberg on 7/25/16.
//  Copyright © 2016 Zev Eisenberg. All rights reserved.
//

import Foundation

final class MBTAViewModel {

    enum Header {

        case subway(route: String, destination: String)
        case bus(route: String, destination: String)

    }

    enum UpcomingTrips {

        case two(next: TimeInterval, later: TimeInterval)
        case one(next: TimeInterval)
        case none

    }

    typealias RouteDescription = (routeType: ModeType, routeId: String, directionId: String)

    enum Result {

        case success([(trips: UpcomingTrips, header: Header?)])
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
                    let upcomingTripsViewModelsAndHeaders = MBTAViewModel.upcomingTripsViewModelsAndHeaders(from: sullivan)
                    completion(.success(upcomingTripsViewModelsAndHeaders))
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

    static func upcomingTripsViewModelsAndHeaders(from stop: Stop) -> [(trips: UpcomingTrips, header: Header?)] {

        let routeDescriptions = [
            (routeType: ModeType.subway, routeId: "Orange", directionId: "0"),
            (routeType: ModeType.bus, routeId: "747", directionId: "1"),
            (routeType: ModeType.bus, routeId: "86", directionId: "1"),
            (routeType: ModeType.bus, routeId: "90", directionId: "1"),
            (routeType: ModeType.bus, routeId: "91", directionId: "1"),
            ]

        return routeDescriptions.map { description in
            return upcomingTripsAndHeader(fromStop: stop, routeDescription: description)
        }

    }

    static func upcomingTripsAndHeader(fromStop stop: Stop, routeDescription: RouteDescription) -> (trips: UpcomingTrips, header: Header?) {

        let (routeType, routeId, directionId) = routeDescription

        let routesAndTrips = stop.modes
            .filter { stopMode in stopMode.type == routeType }
            .flatMap { stopMode in
                stopMode.routes
                    .filter { route in route.identifier == routeId }
                    .flatMap { route in
                        route.directions
                            .filter { direction in direction.identifier == directionId }
                            .flatMap { direction in direction.trips }
                            .map { trip in (route: route, trip: trip) }
                }
        }

        guard !routesAndTrips.isEmpty else {
            return (trips: .none, header: nil)
        }

        let routeAndTrips = (route: routesAndTrips[0].route, trips: routesAndTrips.flatMap { tuple in tuple.trip })

        let header: Header
        switch routeType {
        case .bus:
            header = .bus(route: routeAndTrips.route.name, destination: routeAndTrips.trips.first?.headsign ?? "TODO: capture headsign if there are no trips")
        case .subway:
            header = .subway(route: routeAndTrips.route.name, destination: routeAndTrips.trips.first?.headsign ?? "TODO: capture headsign if there are no trips")
        default:
            fatalError("Unexpected route type: \(routeType)")
        }

        let first = routeAndTrips.trips[safe: 0]
        let second = routeAndTrips.trips[safe: 1]

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

        return (trips: upcomingTrips, header: header)
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

extension MBTAViewModel.Header: Equatable {

    static func == (lhs: MBTAViewModel.Header, rhs: MBTAViewModel.Header) -> Bool {
        switch (lhs, rhs) {
        case (.subway(let aRoute, let aDestination), .subway(let bRoute, let bDestination)):
            return aRoute == bRoute && aDestination == bDestination
        case (.bus(let aRoute, let aDestination), .bus(let bRoute, let bDestination)):
            return aRoute == bRoute && aDestination == bDestination
        default:
            return false
        }
    }

}
