//
//  Tagged.swift
//  Services
//
//  Created by Zev Eisenberg on 5/28/20.
//

/// Based on PointFree's [Tagged type](https://github.com/pointfreeco/swift-tagged/blob/master/Sources/Tagged/Tagged.swift).
public struct Tagged<Tag, RawValue>: Hashable, Codable where RawValue: Hashable & Codable {

    public var rawValue: RawValue

    public init(rawValue: RawValue) {
        self.rawValue = rawValue
    }

    public init(_ rawValue: RawValue) {
        self.init(rawValue: rawValue)
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        rawValue = try container.decode(RawValue.self)
    }
}

extension Tagged: RawRepresentable {}

extension Tagged: ExpressibleByIntegerLiteral where RawValue: ExpressibleByIntegerLiteral, RawValue.IntegerLiteralType == IntegerLiteralType {
    public init(integerLiteral value: RawValue.IntegerLiteralType) {
        self.init(rawValue: .init(integerLiteral: value))
    }
}

extension Tagged: ExpressibleByUnicodeScalarLiteral where RawValue: ExpressibleByStringLiteral, RawValue.StringLiteralType == StringLiteralType {
    public init(unicodeScalarLiteral value: RawValue.UnicodeScalarLiteralType) {
        self.init(rawValue: .init(unicodeScalarLiteral: value))
    }
}

extension Tagged: ExpressibleByExtendedGraphemeClusterLiteral where RawValue: ExpressibleByStringLiteral, RawValue.StringLiteralType == StringLiteralType {
    public init(extendedGraphemeClusterLiteral value: RawValue.ExtendedGraphemeClusterLiteralType) {
        self.init(rawValue: .init(extendedGraphemeClusterLiteral: value))
    }

}

extension Tagged: ExpressibleByStringLiteral where RawValue: ExpressibleByStringLiteral, RawValue.StringLiteralType == StringLiteralType {
    public init(stringLiteral value: RawValue.StringLiteralType) {
        self.init(rawValue: .init(stringLiteral: value))
    }
}
