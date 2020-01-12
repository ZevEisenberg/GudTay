//
//  FlatCache.swift
//  Services
//
//  Created by Zev Eisenberg on 4/16/18.
//

import Foundation.NSHashTable

public protocol Cachable {

    var cache: FlatCache? { get set }

}

internal protocol AnyRow {
    var untypedStorage: [AnyIdentifier: Any] { get }
}

extension FlatCache.Row: AnyRow {
    var untypedStorage: [AnyIdentifier: Any] {
        let newDict = Dictionary(uniqueKeysWithValues: storage.map { key, value in (AnyIdentifier(key), value) })
        return newDict
    }
}

public class FlatCache {

    static func key(for type: Any.Type) -> String {
        String(describing: type)
    }

    fileprivate struct Row<T> {

        private var storage: [Identifier<T>: T] = [:]

        subscript(_ id: Identifier<T>) -> T? {
            get {
                storage[id]
            }
            set {
                storage[id] = newValue
            }
        }

        var values: [T] {
            Array(storage.values)
        }

    }

    internal let workQueue = DispatchQueue(label: "com.zeveisenberg.flatCache.workQueue", attributes: .concurrent)
    internal var valueStorage: [String: Any] = [:]

    internal let observerStorage: NSHashTable<Observer> = .weakObjects()
    internal var notificationStorage = Set<Observer.Key>()
    internal var notificationBatchCount = 0

    private func updateRow<T>(for type: T.Type, change: @escaping (inout Row<T>) -> Void, completion: @escaping () -> Void) {
        let typeName = FlatCache.key(for: T.self)
        performChange {
            var lookupRow: Row<T>
            if let row = self.valueStorage[typeName] as? Row<T> {
                lookupRow = row
            }
            else {
                lookupRow = Row<T>()
            }
            change(&lookupRow)
            self.valueStorage[typeName] = lookupRow
            completion()
        }
    }

    private func row<T, Result>(for type: T.Type, lookup: (Row<T>) throws -> Result?) rethrows -> Result? {
        let typeName = FlatCache.key(for: T.self)
        return try workQueue.sync {
            if let row = valueStorage[typeName] as? Row<T> {
                return try lookup(row)
            }
            return nil
        }
    }

    func performChange(action: @escaping () -> Void) {
        workQueue.async(flags: .barrier) {
            action()
        }
    }

    func set<T: Identifiable>(_ value: T) {
        set(value, for: value.id)
    }

    func set<T>(_ value: T, for id: Identifier<T>) {
        updateRow(for: T.self, change: { $0[id] = value }, completion: { [weak self] in
            self?.notifyObservers(for: T.self, ids: [id])
        })
    }

    func set<T: Identifiable>(_ values: [T]) {
        updateRow(for: T.self, change: { $0.add(values) }, completion: { [weak self] in
            self?.notifyObservers(for: T.self, ids: values.ids)
        })
    }

    func any<T: Identifiable>(ofType: T.Type = T.self, where predicate: (T) throws -> Bool) rethrows -> T? {
        try row(for: T.self, lookup: { row in
            try row.values.first(where: predicate)
        })
    }

    func deleteAll<T: Identifiable, Coll: Collection>(_ type: T.Type, excluding excluded: Coll) where Coll.Element == T {
        var removed = [Identifier<T>]()
        updateRow(
            for: T.self,
            change: ({
                removed = $0.removeAll(excluding: excluded.ids)
            }),
            completion: ({ [weak self] in
                if !removed.isEmpty {
                    self?.notifyObservers(for: T.self, ids: removed)
                }
            }))
    }

    func delete<T: Identifiable>(_ value: T) {
        updateRow(for: T.self, change: { $0.remove([value]) }, completion: { [weak self] in
            self?.notifyObservers(for: T.self, ids: [value.id])
        })
    }

    func delete<T: Identifiable>(_ values: [T]) {
        updateRow(for: T.self, change: { $0.remove(values) }, completion: { [weak self] in
            self?.notifyObservers(for: T.self, ids: values.ids)
        })
    }

    func get<T, Coll: Collection>(allOfType type: T.Type = T.self, with ids: Coll) -> [T] where Coll.Element == Identifier<T> {
        ids.compactMap { get(id: $0, type: type) }
    }

    func get<T>(id: Identifier<T>, type: T.Type = T.self) -> T? {
        row(for: T.self, lookup: { $0[id] })
    }

    func all<T>(ofType: T.Type) -> [T] {
        row(for: T.self, lookup: { $0.values }) ?? []
    }

    func clearCache() {
        performChange {
            self.valueStorage = [:]
        }
    }

    public init() {}
}

extension FlatCache.Row where T: Identifiable {
    mutating func add(_ values: [T]) {
        for value in values {
            storage[value.id] = value
        }
    }
    mutating func remove(_ values: [T]) {
        for value in values {
            storage.removeValue(forKey: value.id)
        }
    }
    mutating func remove<Coll: Collection>(_ ids: Coll) where Coll.Element == Identifier<T> {
        for id in ids {
            storage.removeValue(forKey: id)
        }
    }
    mutating func removeAll<Coll: Collection>(excluding excludedIds: Coll) -> [Identifier<T>] where Coll.Element == Identifier<T> {
        let deleteKeys = Set(storage.keys).subtracting(Set(excludedIds))
        remove(deleteKeys)
        return Array(deleteKeys)
    }
}
