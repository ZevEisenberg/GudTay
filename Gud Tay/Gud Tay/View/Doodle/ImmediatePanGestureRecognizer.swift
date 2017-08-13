//
//  ImmediatePanGestureRecognizer.swift
//  Gud Tay
//
//  Created by Zev Eisenberg on 8/13/17.
//  Copyright © 2017 Zev Eisenberg. All rights reserved.
//

import UIKit.UIGestureRecognizerSubclass

final class ImmediatePanGestureRecognizer: UIPanGestureRecognizer {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)

        // Prevent touches from other views from triggering this gesture
        if touches.first?.view == view {
            state = .began
        }
    }

}
