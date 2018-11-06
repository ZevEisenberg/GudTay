//
//  DebugMenuConfiguration.swift
//  GudTay
//
//  Created by ZevEisenberg on 11/1/16.
//  Copyright © 2017 ZevEisenberg. All rights reserved.
//

import Services
import Swiftilities
import UIKit

class DebugMenuConfiguration: AppLifecycle {

    var isEnabled: Bool {
        return BuildType.active == .internal || BuildType.active == .debug
    }

    func onDidLaunch(application: UIApplication, launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        DefaultBehaviors(behaviors: [DebugMenuBehavior()]).inject()
    }

}

public class DebugMenuBehavior: ViewControllerLifecycleBehavior {

    public init() {}
    public func afterAppearing(_ viewController: UIViewController, animated: Bool) {
        DebugMenu.enableDebugGesture(viewController)
    }

}
