//
//  FlatCache+Observer.swift
//  Services
//
//  Created by Zev Eisenberg on 4/16/18.
//

public class Observer {
    let key: Key
    let observation: (Any) -> Void

    init(_ key: Key, observation: @escaping (Any) -> Void) {
        self.key = key
        self.observation = observation
    }
}

extension Observer: Hashable {
    public var hashValue: Int { return ObjectIdentifier(self).hashValue }

    public static func == (lhs: Observer, rhs: Observer) -> Bool {
        return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }
}

extension Observer {

    public enum Key: Hashable {
        case entity(typeName: String, id: AnyIdentifier)
        case type(typeName: String)
    }

}

extension Observer.Key {

    var typeName: String {
        switch self {
        case .entity(let entity): return entity.typeName
        case .type(let typeName): return typeName
        }
    }

}

extension FlatCache {

    public func observe<T>(_ identifier: Identifier<T>, observation: @escaping (T) -> Void) -> Observer where T: Identifiable {
        let key = Observer.Key.entity(typeName: FlatCache.key(for: T.self), id: AnyIdentifier(identifier))
        let observer = Observer(key) { (value) in
            if let value = value as? T { observation(value) }
        }

        workQueue.async(flags: .barrier) {
            self.observerStorage.add(observer)
        }

        return observer
    }

    public func observe<T>(type: T.Type = T.self, observation: @escaping ([T]) -> Void) -> Observer {
        let key = Observer.Key.type(typeName: FlatCache.key(for: type))
        let observer = Observer(key) { (value) in
            if let value = value as? [T] {
                observation(value)
            }
        }

        workQueue.async(flags: .barrier) {
            self.observerStorage.add(observer)
        }

        return observer
    }

    internal func beginNotificationBatch() {
        workQueue.sync(flags: .barrier) {
            self.notificationBatchCount += 1
        }
    }

    internal func endNotificationBatch() {
        workQueue.async(flags: .barrier) {
            self.notificationBatchCount -= 1
            self.notifyObservers()
        }
    }

    internal func deferObserverNotifications<T>(during closure: () throws -> T) rethrows -> T {
        beginNotificationBatch()
        defer {
            endNotificationBatch()
        }
        return try closure()
    }

    internal func touchedValuesForObservers(for keys: Set<Observer.Key>) -> [Observer: Any] {
        let pairs: [(Observer, Any)] = observerStorage
            .allObjects
            .filter { keys.contains($0.key) }
            .compactMap { observer in
                guard let row = valueStorage[observer.key.typeName] as? AnyRow else {
                    return nil
                }
                if case .entity(let entity) = observer.key, let value = row.untypedStorage[entity.id] {
                    return (observer, value)
                }
                else if case .type = observer.key {
                    return (observer, Array(row.untypedStorage.values))
                }
                return nil
        }

        return Dictionary(uniqueKeysWithValues: pairs)
    }

    func notifyObservers<T>(for type: T.Type, ids: [Identifier<T>]) {
        //keys for all updated ids
        let typeName = FlatCache.key(for: type)
        var keys = ids.map { Observer.Key.entity(typeName: typeName, id: AnyIdentifier($0)) }
        //key for updated type
        keys.append(Observer.Key.type(typeName: FlatCache.key(for: type)))
        notificationStorage.formUnion(keys)
        notifyObservers()
    }

    /// This MUST be called from the workQueue
    private func notifyObservers() {
        if notificationBatchCount <= 0 {
            let touchedValues = touchedValuesForObservers(for: notificationStorage)
            notificationStorage.removeAll()
            DispatchQueue.main.async {
                for (observer, value) in touchedValues {
                    observer.observation(value)
                }
            }
        }
    }

}

extension Entity {

    public func observe(_ observation: @escaping (Self) -> Void) -> Observer? {
        return cache?.observe(id, observation: observation)
    }

    public static func observeAll(_ observation: @escaping ([Self]) -> Void) -> Observer? {
        let cache = APIClient.mbta.cache
        return cache.observe(observation: observation)
    }

}
