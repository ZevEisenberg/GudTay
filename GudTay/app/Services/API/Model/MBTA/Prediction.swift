//
//  Prediction.swift
//  Services
//
//  Created by Zev Eisenberg on 4/17/18.
//

import Foundation.NSDate
import JSONAPI

typealias APIPrediction = ResourceObject<PredictionDescription, NoMetadata, NoLinks, String>

/// top-level API response for predictions
typealias PredictionDocument = JSONAPI.Document<ManyResourceBody<APIPrediction>, NoMetadata, NoLinks, Include3<APIStop, APIRoute, APITrip>, NoAPIDescription, UnknownJSONAPIError>

enum PredictionDescription: ResourceObjectDescription {
    static var jsonType: String { "prediction" }

    struct Attributes: JSONAPI.Attributes {
        let arrivalTime: Attribute<Date?>
        let departureTime: Attribute<Date?>
        let directionId: Attribute<Int>
        let status: Attribute<String?>
        let stopSequence: Attribute<Int?>
        let scheduleRelationship: Attribute<ScheduleRelationship?>
    }

    struct Relationships: JSONAPI.Relationships {
        let route: ToOneRelationship<APIRoute, NoMetadata, NoLinks>
        let stop: ToOneRelationship<APIStop, NoMetadata, NoLinks>
        let trip: ToOneRelationship<APITrip, NoMetadata, NoLinks>
    }
}

public struct Prediction {

    public let id: Tagged<Prediction, String>

    public let arrivalTime: Date?
    public let departureTime: Date?
    public let directionId: Int
    public let status: String? // "2 stops away"
    public let stopSequence: Int?
    public let scheduleRelationship: ScheduleRelationship?

    // Relationships
    public let route: Route?
    public let stop: Stop?
    public let trip: Trip?

    static func from(document: PredictionDocument) -> Result<[Self], Error> {
        switch document.body {
        case .errors(let errors, _, _):
            return .failure(JSONAPIErrors(errors: errors))
        case .data(let data):
            let apiPredictions = data.primary.values
            let stops = data.includes[APIStop.self].map(Stop.from(_:))
            let routes = data.includes[APIRoute.self].map(Route.from(_:))
            let trips = data.includes[APITrip.self].map(Trip.from(_:))

            let predictions: [Self] = apiPredictions.compactMap { prediction in
                let attributes = prediction.attributes
                guard attributes.scheduleRelationship.value != .skipped else { return nil }
                let relationships = prediction.relationships
                return Self(
                    id: .init(prediction.id.rawValue),
                    arrivalTime: attributes.arrivalTime.value,
                    departureTime: attributes.departureTime.value,
                    directionId: attributes.directionId.value,
                    status: attributes.status.value,
                    stopSequence: attributes.stopSequence.value,
                    scheduleRelationship: attributes.scheduleRelationship.value,
                    route: routes.first { $0.id.rawValue == relationships.route.id.rawValue },
                    stop: stops.first { $0.id.rawValue == relationships.stop.id.rawValue },
                    trip: trips.first { $0.id.rawValue == relationships.trip.id.rawValue }
                )
            }
            return .success(predictions)
        }
    }

}
