//
//  DebugMenu.swift
//  GudTay
//
//  Created by ZevEisenberg on 10/25/17.
//  Copyright © 2017 ZevEisenberg. All rights reserved.
//

import Services
import Swiftilities

// false positive: https://github.com/realm/SwiftLint/issues/3033
// swiftlint:disable convenience_type
class DebugMenu {

    static func enableDebugGesture(_ viewController: UIViewController) {
        let debugGesture = UITapGestureRecognizer(target: self, action: #selector(openDebugAlert))
        debugGesture.numberOfTapsRequired = 3
        debugGesture.numberOfTouchesRequired = 2
        viewController.view.addGestureRecognizer(debugGesture)
    }

    @objc static func openDebugAlert() {
        guard let delegate = UIApplication.shared.delegate as? AppDelegate,
            let rootViewController = delegate.window?.rootViewController else {
                Log.warn("Debug alert unable to present since the window rootViewController is nil")
                return
        }
        var topMostViewController: UIViewController? = rootViewController
        while topMostViewController?.presentedViewController != nil {
            topMostViewController = topMostViewController?.presentedViewController!
        }

        let debug = UINavigationController(rootViewController: DebugMenuViewController())
        topMostViewController?.present(debug, animated: true, completion: nil)
    }
}
