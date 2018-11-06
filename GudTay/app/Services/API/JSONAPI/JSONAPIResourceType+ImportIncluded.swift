// Generated using Sourcery 0.15.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT


//swiftlint:disable:previous vertical_whitespace

import Swiftilities

func decode(resources: [JSONAPI.Resource], from container: UnkeyedDecodingContainer) throws -> [AnyIdentifiable] {
    assert(resources.count == container.count)

    var container = container

    return try resources.compactMap { (resource: JSONAPI.Resource) -> AnyIdentifiable? in
        switch resource.type {
        case Prediction.apiType: return try container.decode(Prediction.self)
        case Route.apiType: return try container.decode(Route.self)
        case Stop.apiType: return try container.decode(Stop.self)
        case Trip.apiType: return try container.decode(Trip.self)
        default:
            print("Unknown object type: \(resource.type)")
            // Unkeyed decoding container requires a successful decoding to step to the next value.
            // This means we have to successfully decode each value before we can proceed to the next.
            // In the case of an object the app isn't expecting, we decode it to a JSONAPI resource stub, which will succeed or throw.
            _ = try container.decode(JSONAPI.Resource.self)
            return nil
        }
    }
}
