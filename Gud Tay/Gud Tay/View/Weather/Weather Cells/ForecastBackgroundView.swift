//
//  ForecastBackgroundView.swift
//  Gud Tay
//
//  Created by Zev Eisenberg on 8/19/16.
//  Copyright © 2016 Zev Eisenberg. All rights reserved.
//

import UIKit

class ForecastBackgroundView: UIView {

    init() {
        super.init(frame: .zero)
        backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
    }

    @available(*, unavailable) required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @available(*, unavailable) required override init(frame: CGRect) {
        fatalError("init(frame:) has not been implemented")
    }

}
