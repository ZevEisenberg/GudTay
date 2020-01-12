//
//  ToggleButton.swift
//  GudTay
//
//  Created by Zev Eisenberg on 1/7/19.
//

import Then
import UIKit

final class ToggleButton: UIControl {

    // Nested Types

    enum Mode {
        case primary
        case secondary

        var isPrimary: Bool {
            self == .primary
        }

        var opposite: Mode {
            switch self {
            case .primary: return .secondary
            case .secondary: return .primary
            }
        }
    }

    // Public Properties

    var primaryImage: UIImage? {
        get {
            primaryImageView.image
        }
        set {
            primaryImageView.image = newValue
            invalidateIntrinsicContentSize()
            setNeedsLayout()
        }
    }

    var secondaryImage: UIImage? {
        get {
            secondaryImageView.image
        }
        set {
            secondaryImageView.image = newValue
            invalidateIntrinsicContentSize()
            setNeedsLayout()
        }
    }

    private var _mode: Mode = .primary

    var mode: Mode {
        _mode
    }

    // Private Properties

    private let primaryImageView = UIImageView()
    private let secondaryImageView = UIImageView()

    /// The ratio between the small and large image. Must be on the range (0..1]
    private let sizeRatio: CGFloat = 0.5

    /// Amount taller than the larger image that the full control should be,
    /// allowing the smaller image to peek around the corner more. Expressed
    /// as a fraction of the diameter of the larger image. Must be on the range
    /// [0...1]
    private let peekRatio: CGFloat = 0.3

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(primaryImageView)
        addSubview(secondaryImageView)
        bringSubviewToFront(primaryImageView)

        for imageView in [primaryImageView, secondaryImageView] {
            imageView.contentMode = .scaleAspectFit
            imageView.backgroundColor = .white
            imageView.layer.borderColor = UIColor.black.cgColor
            imageView.layer.borderWidth = 1
            imageView.clipsToBounds = true
        }

        addTarget(self, action: #selector(tapped), for: .touchUpInside)
    }

    @available(*, unavailable) required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var intrinsicContentSize: CGSize {
        guard
            let largeImageSize = primaryImage?.size
            else { return CGSize(width: UIView.noIntrinsicMetric, height: UIView.noIntrinsicMetric) }
        let largeImageMaxSideLength = max(largeImageSize.width, largeImageSize.height)
        let peekSize = largeImageMaxSideLength * peekRatio
        let totalSideLength = largeImageMaxSideLength + peekSize
        return CGSize(
            width: totalSideLength.ceiledToNearest(UIScreen.main.scale),
            height: totalSideLength.ceiledToNearest(UIScreen.main.scale)
        )
    }

    override var isHighlighted: Bool {
        didSet {
            for view in [primaryImageView, secondaryImageView] {
                view.backgroundColor = isHighlighted ? .lightGray : .white
            }
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        // Assume that we are square, so just use the height as the side length.
        let totalSideLength = bounds.height

        // h: total height
        // P: peek amount
        // Pr: peek ratio
        // D: diameter of larger image
        // h = D + P
        // P = D * Pr
        // Algebra:
        // h = D + D * Pr
        // h = D(1 + Pr)
        // D = h / (1 + Pr)
        let largeImageSideLength = totalSideLength / (1 + peekRatio)
        let peekAmount = largeImageSideLength * peekRatio

        let largeImageFrame = CGRect(
            x: 0,
            y: peekAmount,
            width: largeImageSideLength,
            height: largeImageSideLength
        ).integralizedToScreenPixels()

        let smallImageSideLength = largeImageSideLength * sizeRatio

        let smallImageFrame = CGRect(
            x: totalSideLength - smallImageSideLength,
            y: totalSideLength - smallImageSideLength,
            width: smallImageSideLength,
            height: smallImageSideLength
        ).integralizedToScreenPixels()

        primaryImageView.frame = mode.isPrimary ? largeImageFrame : smallImageFrame
        primaryImageView.layer.cornerRadius = primaryImageView.frame.height / 2
        secondaryImageView.frame = mode.isPrimary ? smallImageFrame : largeImageFrame
        secondaryImageView.layer.cornerRadius = secondaryImageView.frame.height / 2
    }

    func setMode(_ mode: Mode, animated: Bool) {
        _mode = mode
        self.setNeedsLayout()

        // Ideally, the subview reordering would happen while the views are not overlapping,
        // but that requires creating keyframes and finessing the animation. In the interim,
        // doing the reorder looks better at the beginning than at the end.
        self.bringSubviewToFront(mode.isPrimary ? primaryImageView : secondaryImageView)
        UIView.animate(
            withDuration: animated ? 0.3 : 0.0,
            animations: ({
                self.layoutIfNeeded()
            }),
            completion: { _ in })
    }

}

private extension ToggleButton {

    @objc func tapped() {
        setMode(mode.opposite, animated: true)
        sendActions(for: [.valueChanged, .primaryActionTriggered])
    }

}
