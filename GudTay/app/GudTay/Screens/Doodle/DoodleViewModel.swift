//
//  DoodleViewModel.swift
//  GudTay
//
//  Created by Zev Eisenberg on 12/31/18.
//

import UIKit
import Utilities

extension DoodleViewModel: Actionable {

    enum Action {
        case changedMode(Mode)
    }

}

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

    enum Mode {
        case drawing, erasing
    }

    // Public Properties

    weak var delegate: Delegate?

    var size: CGSize = .zero {
        didSet {
            guard !(size.width == 0 || size.height == 0) else {
                return
            }
            renderer = UIGraphicsImageRenderer(size: size)
        }
    }

    var newImageCallback: ((UIImage, ImageUpdateKind) -> Void)?

    var currentMode: Mode = .drawing {
        didSet {
            if currentMode != oldValue {
                notify(.changedMode(currentMode))
            }
            if currentMode == .erasing {
                restartErasingTimer()
            }
            else {
                invalidateErasingTimer()
            }
        }
    }

    // Private Properties

    private let penContext = DrawingContext(
        lineColor: .black,
        lineWidth: 5
    )
    private let eraserContext = DrawingContext(
        lineColor: Constants.backgroundColor,
        lineWidth: 30
    )

    private var currentDrawingContext: DrawingContext {
        switch currentMode {
        case .drawing: return penContext
        case .erasing: return eraserContext
        }
    }

    private var buffer: UIImage?

    private let persistence: Persistence

    private var renderer: UIGraphicsImageRenderer!

    // After erasing, start a timer. If you haven't erased in a certain amount of time,
    // you automatically get switched back to drawing mode.
    private var erasingTimer: Timer?

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
        restartErasingTimer()
        currentDrawingContext.lastPoints = Array(repeating: point, count: 4)
    }

    func continueTo(_ point: CGPoint) {
        restartErasingTimer()
        currentDrawingContext.addPoint(point)

        // Draw the current stroke in an accumulated bitmap
        buffer = drawLine(fourPoints: currentDrawingContext.lastPoints, buffer: buffer)

        // Replace the imageView contents with the updated image
        buffer.flatMap { newImageCallback?($0, .transient) }
    }

    func endAt(_ point: CGPoint) {
        restartErasingTimer()
        // Update last point for next stroke
        currentDrawingContext.addPoint(point)

        if currentDrawingContext.lastPoints.movesMoreThanOnePt {
            buffer = drawLine(fourPoints: currentDrawingContext.lastPoints, buffer: buffer)
        }
        else {
            buffer = drawDot(at: point)
        }

        buffer.flatMap { newImageCallback?($0, .committedLocally) }

        // Reset drawing points
        currentDrawingContext.lastPoints = Array(repeating: .zero, count: 4)

        if case .onDisk = persistence, let image = buffer {
            ImageIO.persistImage(image, named: Constants.imageName)
        }

    }

    func drawDot(at point: CGPoint) -> UIImage {
        restartErasingTimer()
        return renderer.image { rendererContext in
            let context = rendererContext.cgContext
            if let buffer = buffer {
                buffer.draw(in: bounds)
            }
            else {
                context.setFillColor(Constants.backgroundColor.cgColor)
                context.fill(bounds)
            }

            // Draw the line
            currentDrawingContext.lineColor.setFill()

            let lineWidth = currentDrawingContext.lineWidth
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

            if let buffer = buffer {
                buffer.draw(in: bounds)
            }
            else {
                context.setFillColor(Constants.backgroundColor.cgColor)
                context.fill(CGRect(origin: .zero, size: size))
            }

            // Draw the line
            currentDrawingContext.lineColor.setStroke()
            context.setLineWidth(currentDrawingContext.lineWidth)
            context.setLineCap(.round)
            context.setLineJoin(.round)

            let path = CGPath.smoothedPathSegment(points: fourPoints)
            context.addPath(path)
            context.strokePath()
        }
    }

    func restartErasingTimer() {
        guard currentMode == .erasing else { return }
        erasingTimer?.invalidate()
        erasingTimer = Timer.scheduledTimer(withTimeInterval: 30, repeats: false, block: { [weak self] _ in
            self?.erasingTimer = nil
            self?.currentMode = .drawing
        })
    }

    func invalidateErasingTimer() {
        erasingTimer?.invalidate()
        erasingTimer = nil
    }

}
