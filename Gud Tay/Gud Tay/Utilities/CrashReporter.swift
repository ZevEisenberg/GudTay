//
//  CrashReporter.swift
//  Gud Tay
//
//  Created by Zev Eisenberg on 8/2/16.
//  Copyright © 2016 Zev Eisenberg. All rights reserved.
//

enum CrashReporter {

    static func set(metadataObject: Any, forKey key: String) {
        #if !TESTING
            BuddyBuildSDK.setMetadataObject(metadataObject, forKey: key)
        #endif
    }

}
