//
//  DoodleView.swift
//  Gud Tay
//
//  Created by Cheryl Pedersen on 7/23/17.
//  Copyright © 2017 Zev Eisenberg. All rights reserved.
//

// Code modified from https://techblog.badoo.com/blog/2015/06/15/lets-build-freehand-drawing-in-ios-part-1/

import Anchorage

protocol DoodleViewDelegate: class {

    func showClearPrompt(from button: UIButton, completion: @escaping (_ clear: Bool) -> Void)

}

final class DoodleView: GridView {

    // Public Properties

    weak var delegate: DoodleViewDelegate?

    // Private Properties

    fileprivate var lineColor = UIColor.black
    fileprivate var lineWidth: CGFloat = 5.0

    fileprivate var lastPoint: CGPoint = .zero
    fileprivate var buffer: UIImage?

    fileprivate let imageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        let clearButton = UIButton()
        clearButton.setTitle("🗑", for: .normal)

        // View Hierarchy

        addSubview(imageView)
        addSubview(clearButton)

        // Layout

        imageView.edgeAnchors == edgeAnchors
        clearButton.trailingAnchor == trailingAnchor - 10
        clearButton.bottomAnchor == bottomAnchor - 10

        // Setup

        let pan = UIPanGestureRecognizer(target: self, action: #selector(panned(sender:)))
        addGestureRecognizer(pan)

        clearButton.addTarget(self, action: #selector(clearTapped(sender:)), for: .touchUpInside)
    }

}

// MARK: - Actions

private extension DoodleView {

    @objc func panned(sender: UILongPressGestureRecognizer) {
        let point = sender.location(in: self)
        switch sender.state {
        case .began:
            startAt(point)
        case .changed:
            continueTo(point)
        case .ended, .cancelled:
            endAt(point)
        default:
            fatalError("That's not a thing: \(sender.state)")
        }
    }

    @objc func clearTapped(sender: UIButton) {
        delegate?.showClearPrompt(from: sender, completion: { [weak self] (clear) in
            if clear {
                self?.clearDrawing()
            }
        })
    }

}

// MARK: - Private

private extension DoodleView {

    func startAt(_ point: CGPoint) {
        lastPoint = point
    }

    func continueTo(_ point: CGPoint) {
        // 2. Draw the current stroke in an accumulated bitmap
        buffer = drawLine(from: lastPoint, to: point, buffer: buffer)

        // 3. Replace the imageView contents with the updated image
        imageView.image = buffer

        // 4. Update last point for next stroke
        lastPoint = point
    }

    func endAt(_ point: CGPoint) {
        lastPoint = .zero
    }

    func drawLine(from start: CGPoint, to end: CGPoint, buffer: UIImage?) -> UIImage? {
        // Initialize a full size image. Opaque because we don't need to draw over anything. Will be more performant.
        UIGraphicsBeginImageContextWithOptions(bounds.size, true, 0)

        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }

        context.setFillColor(backgroundColor?.cgColor ?? UIColor.white.cgColor)
        context.fill(bounds)

        // Draw previous buffer first
        buffer?.draw(at: .zero)

        // Draw the line
        lineColor.setStroke()
        context.setLineWidth(lineWidth)
        context.setLineCap(.round)
        context.setLineJoin(.round)

        context.move(to: start)
        context.addLine(to: end)
        context.strokePath()

        // Grab the updated buffer
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

    func clearDrawing() {
        UIGraphicsBeginImageContextWithOptions(bounds.size, true, 0)
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }

        context.setFillColor(backgroundColor?.cgColor ?? UIColor.white.cgColor)
        context.fill(bounds)

        // Grab the updated buffer
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        buffer = image
        imageView.image = image
    }

}
