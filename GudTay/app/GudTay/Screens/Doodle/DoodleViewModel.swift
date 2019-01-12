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
            reconfigureContext()
        }
    }

    var newContextCallback: ((CGContext, ImageUpdateKind) -> Void)?

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

    private let persistence: Persistence

    private var context: CGContext?

    // After erasing, start a timer. If you haven't erased in a certain amount of time,
    // you automatically get switched back to drawing mode.
    private var erasingTimer: Timer?

    /// Convenience getter for working with drawing APIs that expect a bounds rect
    private var bounds: CGRect {
        return CGRect(origin: .zero, size: size)
    }

    init(size: CGSize, persistence: Persistence) {
        self.size = size
        self.persistence = persistence
        reconfigureContext()
    }

    func loadPersistedImage() {
        switch persistence {
        case .inMemory:
            clearDrawing()
        case .onDisk:
            ImageIO.loadPersistedImage(named: Constants.imageName) { result in
                if let image = result.success, let context = self.context {
                    self.drawImage(image)
                    self.newContextCallback?(context, .committedLocally)
                }
            }
        }
    }

    func updateImage(_ newImage: UIImage, kind: ImageUpdateKind) {
        drawImage(newImage)
        if let context = context {
            newContextCallback?(context, kind)
        }
    }

    func startAt(_ point: CGPoint) {
        restartErasingTimer()
        currentDrawingContext.lastPoints = Array(repeating: point, count: 4)
    }

    func continueTo(_ point: CGPoint) {
        restartErasingTimer()
        currentDrawingContext.addPoint(point)

        // Draw the current stroke in an accumulated bitmap
        drawLine(fourPoints: currentDrawingContext.lastPoints)

        // Replace the imageView contents with the updated image
        context.flatMap { newContextCallback?($0, .transient) }
    }

    func endAt(_ point: CGPoint) {
        restartErasingTimer()
        // Update last point for next stroke
        currentDrawingContext.addPoint(point)

        if currentDrawingContext.lastPoints.movesMoreThanOnePt {
            drawLine(fourPoints: currentDrawingContext.lastPoints)
        }
        else {
            drawDot(at: point)
        }

        context.flatMap { newContextCallback?($0, .committedLocally) }

        // Reset drawing points
        currentDrawingContext.lastPoints = Array(repeating: .zero, count: 4)

        if case .onDisk = persistence, let cgImage = context?.makeImage() {
            ImageIO.persistImage(UIImage(cgImage: cgImage), named: Constants.imageName)
        }

    }

    func drawDot(at point: CGPoint) {
        restartErasingTimer()

        context?.setFillColor(currentDrawingContext.lineColor.cgColor)

        let lineWidth = currentDrawingContext.lineWidth
        let rect = CGRect(
            x: point.x - lineWidth / 2,
            y: point.y - lineWidth / 2,
            width: lineWidth,
            height: lineWidth)
        context?.fillEllipse(in: rect)
    }

    func clearDrawing() {
            context?.setFillColor(Constants.backgroundColor.cgColor)
            context?.fill(bounds)
        context.flatMap { newContextCallback?($0, .committedLocally) }
        if persistence == .onDisk, let cgImage = context?.makeImage() {
            ImageIO.persistImage(UIImage(cgImage: cgImage), named: Constants.imageName)
        }
    }

}

private extension DoodleViewModel {

    enum Constants {

        static let imageName = "doodle"
        static let backgroundColor = UIColor.white

    }

    func drawLine(fourPoints: [CGPoint]) {
        context?.setStrokeColor(currentDrawingContext.lineColor.cgColor)
        context?.setLineWidth(currentDrawingContext.lineWidth)
        context?.setLineCap(.round)
        context?.setLineJoin(.round)

        let path = CGPath.smoothedPathSegment(points: fourPoints)
        context?.addPath(path)
        context?.strokePath()
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

    func reconfigureContext() {
        let scale = UIScreen.main.scale
        let width = Int(size.width * scale)
        let bitsPerComponent = 8
        let bytesPerPixel = 4
        context = CGContext(
            data: nil,
            width: width,
            height: Int(size.height * scale),
            bitsPerComponent: bitsPerComponent,
            bytesPerRow: width * bytesPerPixel,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue
        )
        // Scale by screen scale because the context is in pixels, not points.
        // Not sure why we need to invert it, but if we don't, the world is turned upside down.
        context?.scaleBy(x: scale, y: -scale)
        context?.translateBy(x: 0, y: -size.height)
        context?.setFillColor(Constants.backgroundColor.cgColor)
        context?.fill(bounds)
    }

    func drawImage(_ image: UIImage) {
        guard let cgImage = image.cgImage else { return }
        context?.draw(cgImage, in: bounds)
    }

}
