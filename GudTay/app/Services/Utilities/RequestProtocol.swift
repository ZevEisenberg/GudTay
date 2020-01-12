//
//  RequestProtocol.swift
//  Services
//
//  Created by Zev Eisenberg on 4/16/18.
//

import Alamofire
import Utilities

public protocol RequestProtocol: AnyObject {

    var isFinished: Bool { get }

    func cancel()
    @discardableResult func onCompletion(_ closure: @escaping () -> Void) -> Self

}

extension DataRequest: RequestProtocol {

    public var isFinished: Bool {
        progress.isFinished
    }

    public func onCompletion(_ closure: @escaping () -> Void) -> Self {
        response { _ in
            closure()
        }
    }

}

public class RequestBatch {

    private var completions = [() -> Void]()
    private var requests: [RequestProtocol] = []

    public init() {
    }

    @discardableResult public func perform(_ requests: [RequestProtocol]) -> Self {
        self.requests = requests
        let group = DispatchGroup()
        requests.forEach {
            group.enter()
            $0.onCompletion { group.leave() }
        }
        group.notify(queue: .main) {
            self.completions.forEach { $0() }
            self.completions = []
            self.requests = []
        }
        return self
    }

}

extension RequestBatch: RequestProtocol {

    public var isFinished: Bool {
        requests.allSatisfy { $0.isFinished }
    }

    public func cancel() {
        requests.forEach { $0.cancel() }
    }

    public func onCompletion(_ closure: @escaping () -> Void) -> Self {
        self.completions.append(closure)
        return self
    }

}
