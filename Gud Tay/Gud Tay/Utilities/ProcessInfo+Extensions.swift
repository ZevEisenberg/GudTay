//
//  ProcessInfo+Extensions.swift
//  Gud Tay
//
//  Created by Zev Eisenberg on 9/2/16.
//  Copyright © 2016 Zev Eisenberg. All rights reserved.
//

import Foundation.NSProcessInfo

extension ProcessInfo {

    enum EnvironmentKey: String {

        case weatherRefreshInterval
        case weatherAPIClient
        case mbtaAPIClient

    }

}
