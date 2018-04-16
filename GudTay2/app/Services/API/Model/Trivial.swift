//
//  Trivial.swift
//  Services
//
//  Created by Zev Eisenberg on 4/16/18.
//

struct Trivial: Entity, Cachable {
    var cache: FlatCache?

    var id: Identifier<Trivial>

    static var apiType: String {
        return "trivial"
    }

    enum AttributeKeys: CodingKey {}
    enum RelationshipKeys: CodingKey {}

    init(helper: JSONAPI.DecodingHelper<Trivial, AttributeKeys, RelationshipKeys>) throws {
        self.id = helper.id
        self.cache = helper.decoder.cache
    }

}
