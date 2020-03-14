//
//  Result+Utilities.swift
//  Utilities
//
//  Created by Zev Eisenberg on 12/31/18.
//

public extension Result {

    var isSuccess: Bool {
        switch self {
        case .success: return true
        case .failure: return false
        }
    }

    var success: Success? {
        switch self {
        case .success(let success): return success
        case .failure: return nil
        }
    }

    var error: Failure? {
        switch self {
        case .success: return nil
        case .failure(let failure): return failure
        }
    }

}
