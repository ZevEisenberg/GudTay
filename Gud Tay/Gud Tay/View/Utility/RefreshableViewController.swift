//
//  RefreshableViewController.swift
//  Gud Tay
//
//  Created by Zev Eisenberg on 8/18/16.
//  Copyright © 2016 Zev Eisenberg. All rights reserved.
//

import UIKit

class RefreshableViewController: UIViewController {

    // Public Properties

    var errorHandler: ((String) -> Void)?

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    @available(*, unavailable) required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension RefreshableViewController {

    func processRefreshError(_ error: ViewModel.RefreshError) {
        switch error {
        case .jsonWasNil:
            errorHandler?("Error: JSON from server was nil")
        case .networkError(let nsError):
            errorHandler?("Network error: \(nsError.localizedDescription)")
        case .jsonError(let jsonError):
            errorHandler?("JSON Error: \(jsonError)")
        case .genericError(let genericError):
            errorHandler?("Generic error: \(genericError)")
        }
    }

}
