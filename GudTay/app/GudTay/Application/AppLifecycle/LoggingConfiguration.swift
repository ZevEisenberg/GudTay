//
//  LoggingConfiguration.swift
//  GudTay
//
//  Created by ZevEisenberg on 11/1/16.
//  Copyright © 2017 ZevEisenberg. All rights reserved.
//

import Services
import Swiftilities
import UIKit

struct LoggingConfiguration: AppLifecycle {

    func onDidLaunch(application: UIApplication, launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        Log.logLevel = .info
        NetworkLog.logLevel = .info
        Log.handler = { (level, message) in
            LogService.add(message: message)
        }
    }

}
