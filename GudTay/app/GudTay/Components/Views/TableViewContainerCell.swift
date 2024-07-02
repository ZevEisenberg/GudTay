//
//  TableViewContainerCell.swift
//  GudTay
//
//  Created by ZevEisenberg on 6/6/17.
//
//

import Anchorage
import UIKit

public protocol Reusable {
    func prepareForReuse()
}

public class TableViewContainerCell<View: UIView>: UITableViewCell {

    public var containedView: View? {
        didSet {
            if let oldValue = oldValue {
                oldValue.removeFromSuperview()
            }
            if let containedView = containedView {
                containerView.addSubview(containedView)
                containedView.edgeAnchors == containerView.edgeAnchors
            }
        }
    }

    public lazy var containerView: UIView = {
        let containerView = UIView()

        containerView.backgroundColor = .white
        containerView.layer.masksToBounds = true

        return containerView
    }()

    private let shadowView: UIView = {
        let shadowView = UIView()
        shadowView.backgroundColor = .white

        return shadowView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(shadowView)
        contentView.addSubview(containerView)

        shadowView.edgeAnchors == contentView.layoutMarginsGuide.edgeAnchors
        containerView.edgeAnchors == shadowView.edgeAnchors

        contentView.preservesSuperviewLayoutMargins = false
        [self, shadowView, containerView].forEach { $0.backgroundColor = .clear }
    }

    @available(*, unavailable) public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        updateShadowPath()
    }

    override public func prepareForReuse() {
        super.prepareForReuse()
        backgroundColor = nil
        contentView.backgroundColor = nil
        if let reusableView = containedView as? Reusable {
            reusableView.prepareForReuse()
        }
    }

    override public var bounds: CGRect {
        didSet {
            updateShadowPath()
        }
    }

    override public var frame: CGRect {
        didSet {
            updateShadowPath()
        }
    }

    public var cornerRadius: CGFloat = 0 {
        didSet {
            containerView.layer.cornerRadius = cornerRadius
            shadowView.layer.cornerRadius = containerView.layer.cornerRadius
            shadowView.layer.shadowRadius = cornerRadius
        }
    }

    public var shadowConfiguration: (opacity: Float, offset: CGSize, color: UIColor?, blur: CGFloat)? {
        didSet {
            let config = shadowConfiguration ?? (0, .zero, nil, 0)
            shadowView.layer.shadowOpacity = config.opacity
            shadowView.layer.shadowOffset = config.offset
            shadowView.layer.shadowColor = config.color?.cgColor
            shadowView.layer.shadowRadius = config.blur
        }
    }

}

private extension TableViewContainerCell {

    /// On iOS 9, it is sufficient to call this from `layoutSubviews()`.
    /// But on iOS 10, that method is called only once, and the `bounds`
    /// is `CGRect.zero` at that point. To work around this, we also call
    /// this function from property observers on `frame` and `bounds`.
    func updateShadowPath() {
        let radii = CGSize(width: cornerRadius, height: cornerRadius)
        shadowView.layer.shadowPath = UIBezierPath(
            roundedRect: shadowView.bounds,
            byRoundingCorners: .allCorners,
            cornerRadii: radii).cgPath
    }
}
