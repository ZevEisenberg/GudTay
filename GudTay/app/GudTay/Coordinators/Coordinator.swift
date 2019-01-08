//
//  Coordinator.swift
//  GudTay
//
//  Created by ZevEisenberg on 3/24/17.
//  Copyright © 2017 ZevEisenberg. All rights reserved.
//

import Foundation

/// Coordinators inherit from `NSObject` because they often need to be made
/// delegates or message receivers.
protocol Coordinator: AnyObject, NSObjectProtocol { }
