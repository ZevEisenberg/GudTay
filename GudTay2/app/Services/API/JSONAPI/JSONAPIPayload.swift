//
//  JSONAPIPayload.swift
//  Services
//
//  Created by Zev Eisenberg on 4/16/18.
//

import Foundation

extension JSONAPI {

    struct Payload<T: Decodable>: Decodable {

        let data: T
        let included: [AnyIdentifiable]

        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: JSONAPI.ResponseKeys.self)
            included = try JSONAPI.decodeIncluded(from: values)
            data = try values.decode(T.self, forKey: .data)
        }

    }

}
