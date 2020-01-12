//
//  Actionable.swift
//  GudTay
//
//  Created by ZevEisenberg on 3/8/18.
//  Copyright © 2018 ZevEisenberg. All rights reserved.
//

import UIKit

protocol Actionable: AnyObject {
    associatedtype ActionType
    associatedtype Delegate

    func notify(_ action: ActionType)
}

// SwiftLint bug/conflict between opening_brace
// and implicit_return: https://github.com/realm/SwiftLint/issues/3034
// swiftlint:disable opening_brace

extension Actionable {

    func notify(_ action: ActionType) -> () -> Void {
        { [weak self] in
            self?.notify(action)
        }
    }

    func notify(_ action: ActionType) -> (UIControl) -> Void {
        { [weak self] _ in
            self?.notify(action)
        }
    }

    func notify(_ action: ActionType) -> (UIAlertAction) -> Void {
        { [weak self] _ in
            self?.notify(action)
        }
    }

}
