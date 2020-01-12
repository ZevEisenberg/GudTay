//
//  GridView.swift
//  Gud Tay
//
//  Created by Zev Eisenberg on 7/26/16.
//  Copyright © 2016 Zev Eisenberg. All rights reserved.
//

import Anchorage
import Swiftilities
import UIKit

class GridView: UIView {

    // Public Properties

    let contentView = UIView(axId: "contentView")

    var borderedEdges: UIRectEdge = .all {
        didSet {
            let pairs: [UIRectEdge: HairlineView] = [
                .top: top,
                .left: leading,
                .bottom: bottom,
                .right: trailing,
            ]
            for (edge, hairline) in pairs {
                hairline.isHidden = !borderedEdges.contains(edge)
            }
        }
    }

    // Private Properties

    private let top = GridView.hairline(.horizontal)
    private let leading = GridView.hairline(.vertical)
    private let bottom = GridView.hairline(.horizontal)
    private let trailing = GridView.hairline(.vertical)

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white

        // View Hierarchy

        addSubview(contentView)

        addSubview(top)
        addSubview(leading)
        addSubview(bottom)
        addSubview(trailing)

        // Layout

        contentView.edgeAnchors == edgeAnchors

        top.topAnchor == topAnchor
        top.horizontalAnchors == horizontalAnchors

        leading.leadingAnchor == leadingAnchor
        leading.verticalAnchors == verticalAnchors

        bottom.bottomAnchor == bottomAnchor
        bottom.horizontalAnchors == horizontalAnchors

        trailing.trailingAnchor == trailingAnchor
        trailing.verticalAnchors == verticalAnchors
    }

    @available(*, unavailable) required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

private extension GridView {

    private enum Constants {

        static let hairlineColor = UIColor.black
        static let hairlineWidth: CGFloat = 1

    }

    static func hairline(_ axis: NSLayoutConstraint.Axis) -> HairlineView {
        HairlineView(axis: axis, thickness: Constants.hairlineWidth, hairlineColor: Constants.hairlineColor)
    }

}

extension UIRectEdge: Hashable {

    public func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue)
    }
}
