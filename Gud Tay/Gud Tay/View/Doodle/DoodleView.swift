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

    fileprivate var lastPoints: [CGPoint] = Array(repeating: .zero, count: 4)
    fileprivate var buffer: UIImage?

    fileprivate let imageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        let clearButton = UIButton()
        clearButton.setTitle("🔫", for: .normal)
        clearButton.sizeAnchors == CGSize(width: 44, height: 44)

        // View Hierarchy

        contentView.addSubview(imageView)
        contentView.addSubview(clearButton)

        // Layout

        imageView.edgeAnchors == edgeAnchors
        clearButton.trailingAnchor == trailingAnchor
        clearButton.bottomAnchor == bottomAnchor

        // Setup

        let pan = ImmediatePanGestureRecognizer(target: self, action: #selector(panned(sender:)))
        addGestureRecognizer(pan)

        clearButton.addTarget(self, action: #selector(clearTapped(sender:)), for: .touchUpInside)
    }

    override func didMoveToWindow() {
        super.didMoveToWindow()
        ImageIO.loadPersistedImage(named: Constants.imageName) { [weak self] image in
            if let image = image {
                DispatchQueue.main.async {
                    self?.imageView.image = image
                    self?.buffer = image
                }
            }
        }
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

// MARK: - UIGestureRecognizerDelegate

extension DoodleView: UIGestureRecognizerDelegate {

    // Allow tap and pan to recognize at the same time
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

}

// MARK: - Private

private extension DoodleView {

    enum Constants {

        static let imageName = "doodle"

    }

    func startAt(_ point: CGPoint) {
        lastPoints = Array(repeating: point, count: 4)
    }

    func continueTo(_ point: CGPoint) {

        // Update last point for next stroke
        lastPoints.removeFirst()
        lastPoints.append(point)

        // Draw the current stroke in an accumulated bitmap
        buffer = drawLine(fourPoints: lastPoints, buffer: buffer)

        // Replace the imageView contents with the updated image
        imageView.image = buffer
    }

    func endAt(_ point: CGPoint) {
        if point == lastPoints[0] {
            buffer = drawDot(at: point)
            imageView.image = buffer
        }
        lastPoints = Array(repeating: .zero, count: 4)

        if let image = buffer {
            ImageIO.persistImage(image, named: Constants.imageName)
        }
        
    }

    func drawDot(at point: CGPoint) -> UIImage? {
        // Initialize a full size image. Opaque because we don't need to draw over anything. Will be more performant.
        UIGraphicsBeginImageContextWithOptions(bounds.size, true, 0)

        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }

        context.setFillColor(backgroundColor?.cgColor ?? UIColor.white.cgColor)
        context.fill(bounds)

        // Draw previous buffer first
        buffer?.draw(in: bounds)

        // Draw the line
        lineColor.setFill()

        let rect = CGRect(
            x: point.x - lineWidth / 2,
            y: point.y - lineWidth / 2,
            width: lineWidth,
            height: lineWidth)
        context.fillEllipse(in: rect)

        // Grab the updated buffer
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

    func drawLine(fourPoints: [CGPoint], buffer: UIImage?) -> UIImage? {
        // Initialize a full size image. Opaque because we don't need to draw over anything. Will be more performant.
        UIGraphicsBeginImageContextWithOptions(bounds.size, true, 0)

        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }

        context.setFillColor(backgroundColor?.cgColor ?? UIColor.white.cgColor)
        context.fill(bounds)

        // Draw previous buffer first
        buffer?.draw(in: bounds)

        // Draw the line
        lineColor.setStroke()
        context.setLineWidth(lineWidth)
        context.setLineCap(.round)
        context.setLineJoin(.round)

        let path = CGPath.smoothedPathSegment(points: fourPoints)
        context.addPath(path)
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
        if let image = image {
            ImageIO.persistImage(image, named: Constants.imageName)
        }
    }

}
