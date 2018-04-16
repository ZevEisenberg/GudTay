//
//  ViewModel.swift
//  Gud Tay
//
//  Created by Zev Eisenberg on 8/7/16.
//  Copyright © 2016 Zev Eisenberg. All rights reserved.
//

import Foundation.NSError

class ViewModel {

    enum RefreshError: Error {

        case networkError(Error)
        case decodingError(DecodingError)
        case genericError(Error)

    }

}
