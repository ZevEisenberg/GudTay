//
//  CrashReporter.swift
//  Gud Tay
//
//  Created by Zev Eisenberg on 8/2/16.
//  Copyright © 2016 Zev Eisenberg. All rights reserved.
//

enum CrashReporter {

    static func set(metadataObject: AnyObject, forKey key: String) {
        #if !TESTING
            BuddyBuildSDK.setCrashMetadataObject(metadataObject, forKey: key)
        #endif
    }

}
