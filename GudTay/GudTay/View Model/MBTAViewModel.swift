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
        case failure(ViewModel.RefreshError)

    }

    enum RefreshError: Error {

        case networkError(Error)
        case decodingError(DecodingError)
        case genericError(Error)

    }

    private let serviceType: MBTAServiceType.Type

    init(serviceType: MBTAServiceType.Type) {
        self.serviceType = serviceType
    }

    func refresh(completion: @escaping (Result) -> Void) {
        // Hyde Park Ave @ Mt Hope St
        let hydeParkAveAtMtHopeSt = "6480"
        self.serviceType.predictionsByStop(stopId: hydeParkAveAtMtHopeSt) { (apiResult: APIClient.Result<Stop>) in
            switch apiResult {
            case .success(let busStop):
                do {
                    let upcomingTrips = MBTAViewModel.upcomingTrips(from: busStop)
                    completion(.success(upcomingTrips))
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
            (routeType: ModeType.bus, routeId: "32", directionId: "1"),
            ]

        return routeDescriptions.map { description in
            return upcomingTrips(fromStop: stop, routeDescription: description)
        }

    }

    static func upcomingTrips(fromStop stop: Stop, routeDescription: RouteDescription) -> UpcomingTrips {

        let (routeType, routeId, directionId) = routeDescription

        let trips = stop.modes
            .filter { (mode: Mode) in mode.type == routeType }
            .flatMap { (mode: Mode) in mode.routes }
            .filter { (route: Route) in route.identifier == routeId }
            .flatMap { (route: Route) in route.directions }
            .filter { (direction: Direction) in direction.identifier == directionId }
            .flatMap { (direction: Direction) in direction.trips }
            .sorted { $0.predictedSecondsAway < $1.predictedSecondsAway }

        guard !trips.isEmpty else {
            return .none
        }

        let first = trips[0]
        let second = trips[safe: 1]

        let upcomingTrips: UpcomingTrips

        if let second = second {
            upcomingTrips = .two(next: first.predictedSecondsAway, later: second.predictedSecondsAway)
        }
        else {
            upcomingTrips = .one(next: first.predictedSecondsAway)
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

private extension TimeInterval {

    var formattedAsMinutes: String {
        return String(Int(floor(self / 60.0)))
    }

}

extension MBTAViewModel.UpcomingTrips {

    var strings: (next: String, later: String) {
        switch self {
        case .none:
            return (next: "--", later: "--")
        case .one(next: let nextSeconds):
            return (next: nextSeconds.formattedAsMinutes, later: "--")
        case .two(next: let nextSeconds, later: let laterSeconds):
            let secondsAfterNextSeconds = laterSeconds - nextSeconds
            return (next: nextSeconds.formattedAsMinutes, later: secondsAfterNextSeconds.formattedAsMinutes)
        }
    }

}
