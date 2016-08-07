//
//  HairlineView.swift
//  Gud Tay
//
//  Created by Zev Eisenberg on 8/7/16.
//  Copyright © 2016 Zev Eisenberg. All rights reserved.
//

import Anchorage

final class HairlineView: UIView {

    // Public Properties

    var axis: UILayoutConstraintAxis {
        didSet {
            invalidateIntrinsicContentSize()
            setNeedsUpdateConstraints()
        }
    }

    var thickness: CGFloat {
        didSet {
            invalidateIntrinsicContentSize()
            setNeedsUpdateConstraints()
        }
    }

    // Private Properties

    private var thicknessConstraint: NSLayoutConstraint?

    init(axis: UILayoutConstraintAxis, thickness: CGFloat = CGFloat(1.0 / UIScreen.main.scale), color: UIColor? = UIColor(white: 0.0, alpha: 0.3)) {
        self.axis = axis
        self.thickness = thickness
        super.init(frame: .zero)
        self.backgroundColor = color
        self.accessibilityIdentifier = "hairline"
        setNeedsUpdateConstraints()
    }

    override var intrinsicContentSize: CGSize {
        var size = CGSize(width: UIViewNoIntrinsicMetric, height: UIViewNoIntrinsicMetric)
        switch axis {
        case .horizontal:
            size.height = thickness
        case .vertical:
            size.width = thickness
        }
        return size
    }

    @available(*, unavailable) required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func updateConstraints() {
        thicknessConstraint?.isActive = false
        thicknessConstraint = ((axis == .horizontal ? heightAnchor : widthAnchor) == thickness)
        super.updateConstraints()
    }

    override func contentHuggingPriority(for axis: UILayoutConstraintAxis) -> UILayoutPriority {
        return (self.axis == axis ? UILayoutPriorityRequired : UILayoutPriorityDefaultLow)
    }

    override func contentCompressionResistancePriority(for axis: UILayoutConstraintAxis) -> UILayoutPriority {
        return contentHuggingPriority(for: axis)
    }

}
