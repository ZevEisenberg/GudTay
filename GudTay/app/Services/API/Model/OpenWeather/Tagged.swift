//
//  Tagged.swift
//  Services
//
//  Created by Zev Eisenberg on 5/28/20.
//

public extension OpenWeatherAPI {

    /// Based on PointFree's [Tagged type](https://github.com/pointfreeco/swift-tagged/blob/master/Sources/Tagged/Tagged.swift).
    struct Tagged<Tag, RawValue>: Hashable, Codable where RawValue: Hashable & Codable {

        public var rawValue: RawValue

        public init(rawValue: RawValue) {
            self.rawValue = rawValue
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            rawValue = try container.decode(RawValue.self)
        }
    }

}

extension OpenWeatherAPI.Tagged: RawRepresentable {}

extension OpenWeatherAPI.Tagged: ExpressibleByIntegerLiteral where RawValue: ExpressibleByIntegerLiteral, RawValue.IntegerLiteralType == IntegerLiteralType {
    public init(integerLiteral value: RawValue.IntegerLiteralType) {
        self.init(rawValue: .init(integerLiteral: value))
    }
}
