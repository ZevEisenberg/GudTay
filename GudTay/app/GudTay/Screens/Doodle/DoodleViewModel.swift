//
//  DoodleViewModel.swift
//  GudTay
//
//  Created by Zev Eisenberg on 12/31/18.
//

import UIKit
import Utilities

final class DoodleViewModel {

    // Nested Types

    enum Persistence {
        case onDisk, inMemory
    }

    enum ImageUpdateKind {
        case transient
        case committedLocally
        case fromNetwork
    }

    // Public Properties

    var size: CGSize = .zero {
        didSet {
            guard !(size.width == 0 || size.height == 0) else {
                return
            }
            renderer = UIGraphicsImageRenderer(size: size)
        }
    }

    var newImageCallback: ((UIImage, ImageUpdateKind) -> Void)?

    // Private Properties

    private var lineColor = UIColor.black
    private var lineWidth: CGFloat = 5.0

    private var lastPoints: [CGPoint] = Array(repeating: .zero, count: 4)
    private var buffer: UIImage?

    private let persistence: Persistence

    private var renderer: UIGraphicsImageRenderer!

    /// Convenience getter for working with drawing APIs that expect a bounds rect
    private var bounds: CGRect {
        return CGRect(origin: .zero, size: size)
    }

    init(size: CGSize, persistence: Persistence) {
        self.size = size
        renderer = UIGraphicsImageRenderer(size: size)
        self.persistence = persistence
    }

    func loadPersistedImage() {
        switch persistence {
        case .inMemory:
            clearDrawing()
        case .onDisk:
            ImageIO.loadPersistedImage(named: Constants.imageName) { result in
                if let image = result.success {
                    self.buffer = image
                    self.newImageCallback?(image, .committedLocally)
                }
            }
        }
    }

    func updateImage(_ newImage: UIImage, kind: ImageUpdateKind) {
        buffer = newImage
        newImageCallback?(newImage, kind)
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
        buffer.flatMap { newImageCallback?($0, .transient) }
    }

    func endAt(_ point: CGPoint) {
        // Update last point for next stroke
        lastPoints.removeFirst()
        lastPoints.append(point)

        if lastPoints.movesMoreThanOnePt {
            buffer = drawLine(fourPoints: lastPoints, buffer: buffer)
        }
        else {
            buffer = drawDot(at: point)
        }

        buffer.flatMap { newImageCallback?($0, .committedLocally) }

        // Reset drawing points
        lastPoints = Array(repeating: .zero, count: 4)

        if case .onDisk = persistence, let image = buffer {
            ImageIO.persistImage(image, named: Constants.imageName)
        }

    }

    func drawDot(at point: CGPoint) -> UIImage {
        return renderer.image { rendererContext in
            let context = rendererContext.cgContext
            context.setFillColor(Constants.backgroundColor.cgColor)
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
        }
    }

    func clearDrawing() {
        let image = renderer.image { rendererContext in
            let context = rendererContext.cgContext
            context.setFillColor(Constants.backgroundColor.cgColor)
            context.fill(bounds)
        }
        buffer = image
        buffer.flatMap { newImageCallback?($0, .committedLocally) }
        if persistence == .onDisk {
            ImageIO.persistImage(image, named: Constants.imageName)
        }
    }

}

private extension DoodleViewModel {

    enum Constants {

        static let imageName = "doodle"
        static let backgroundColor = UIColor.white

    }

    func drawLine(fourPoints: [CGPoint], buffer: UIImage?) -> UIImage {
        return renderer.image { (rendererContext: UIGraphicsRendererContext) in
            let context = rendererContext.cgContext
            context.setFillColor(Constants.backgroundColor.cgColor)
            context.fill(CGRect(origin: .zero, size: size))

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
        }
    }

}
