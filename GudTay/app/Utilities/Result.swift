//
//  Result.swift
//  Utilities
//
//  Created by Zev Eisenberg on 12/31/18.
//

public enum Result<Success> {

    case success(Success)
    case failure(Error)

    public var isSuccess: Bool {
        switch self {
        case .success: return true
        case .failure: return false
        }
    }

    public var success: Success? {
        switch self {
        case .success(let success): return success
        case .failure: return nil
        }
    }

    public var error: Error? {
        switch self {
        case .success: return nil
        case .failure(let error): return error
        }
    }

}
