//
//  DoodleViewModel.swift
//  GudTay
//
//  Created by Zev Eisenberg on 12/31/18.
//

import UIKit
import Utilities

protocol DoodleViewModelDelegate: AnyObject {

    func doodleViewModel(_ doodleViewModel: DoodleViewModel, did action: DoodleViewModel.Action)
}

extension DoodleViewModel {

    typealias Delegate = DoodleViewModelDelegate

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

    var newImageCallback: ((CGImage, ImageUpdateKind) -> Void)?

    var currentMode: Mode = .drawing {
        didSet {
            if currentMode != oldValue {
                delegate?.doodleViewModel(self, did: .changedMode(currentMode))
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

    private let pen = Brush(
        lineColor: .black,
        lineWidth: 5
    )
    private let eraser = Brush(
        lineColor: Constants.backgroundColor,
        lineWidth: 30
    )

    private var currentBrush: Brush {
        switch currentMode {
        case .drawing: return pen
        case .erasing: return eraser
        }
    }

    private let persistence: Persistence

    private var context: CGContext?

    // After erasing, start a timer. If you haven't erased in a certain amount of time,
    // you automatically get switched back to drawing mode.
    private var erasingTimer: Timer?

    /// Convenience getter for working with drawing APIs that expect a bounds rect
    private var bounds: CGRect {
        CGRect(origin: .zero, size: size)
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
                DispatchQueue.main.async {
                    if let image = result.success {
                        self.drawImage(image, inverted: true, updateKind: .transient)
                        self.context?.makeImage().flatMap { self.newImageCallback?($0, .committedLocally) }
                    }
                }
            }
        }
    }

    func updateImage(_ newImage: UIImage, kind: ImageUpdateKind) {
        drawImage(newImage, inverted: kind == .fromNetwork, updateKind: kind)
        context?.makeImage().flatMap { newImageCallback?($0, kind) }
    }

    func startAt(_ point: CGPoint) {
        restartErasingTimer()
        currentBrush.lastPoints = Array(repeating: point, count: 4)
    }

    func continueTo(_ point: CGPoint) {
        restartErasingTimer()
        currentBrush.addPoint(point)

        // Draw the current stroke in an accumulated bitmap
        drawLine(fourPoints: currentBrush.lastPoints)

        // Replace the imageView contents with the updated image
        context?.makeImage().flatMap { newImageCallback?($0, .transient) }
    }

    func endAt(_ point: CGPoint) {
        restartErasingTimer()
        // Update last point for next stroke
        currentBrush.addPoint(point)

        if currentBrush.lastPoints.movesMoreThanOnePt {
            drawLine(fourPoints: currentBrush.lastPoints)
        }
        else {
            drawDot(at: point)
        }

        context?.makeImage().flatMap { newImageCallback?($0, .committedLocally) }

        // Reset drawing points
        currentBrush.lastPoints = Array(repeating: .zero, count: 4)

        if case .onDisk = persistence, let cgImage = context?.makeImage() {
            ImageIO.persistImage(UIImage(cgImage: cgImage), named: Constants.imageName)
        }

    }

    func drawDot(at point: CGPoint) {
        restartErasingTimer()

        context?.setFillColor(currentBrush.lineColor.cgColor)

        let lineWidth = currentBrush.lineWidth
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
        guard let cgImage = context?.makeImage() else { return }
        newImageCallback?(cgImage, .committedLocally)
        if persistence == .onDisk {
            ImageIO.persistImage(UIImage(cgImage: cgImage), named: Constants.imageName)
        }
        // If we just cleared, there's no reason to be erasing, so make sure we're drawing
        currentMode = .drawing
    }

}

private extension DoodleViewModel {

    enum Constants {

        static let imageName = "doodle"
        static let backgroundColor = UIColor.white

    }

    func drawLine(fourPoints: [CGPoint]) {
        context?.setStrokeColor(currentBrush.lineColor.cgColor)
        context?.setLineWidth(currentBrush.lineWidth)
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
        let widthPx = Int(size.width * scale)
        let heightPx = Int(size.height * scale)
        let bitsPerComponent = 8
        let bytesPerPixel = 4
        let bytesPerRow = widthPx * bytesPerPixel
        context = CGContext(
            data: nil,
            width: widthPx,
            height: heightPx,
            bitsPerComponent: bitsPerComponent,
            bytesPerRow: bytesPerRow,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue
        )
        // Scale by screen scale because the context is in pixels, not points.
        // If we don't invert the y axis, the world will be turned upside down
        context?.translateBy(x: 0, y: CGFloat(heightPx))
        context?.scaleBy(x: scale, y: -scale)

        // Start out with a default fill
        context?.setFillColor(Constants.backgroundColor.cgColor)
        context?.fill(bounds)
    }

    func drawImage(_ image: UIImage, inverted: Bool, updateKind: ImageUpdateKind) {
        guard let cgImage = image.cgImage else { return }
        context?.withSavedState { context in
            if inverted {
                // Flip vertically about the top horizontal line
                context.scaleBy(x: 1, y: -1)
                // Move back down
                context.translateBy(x: 0, y: -size.height)
            }
            context.draw(cgImage, in: bounds)
        }
        if case .fromNetwork = updateKind {
            ImageIO.persistImage(image, named: Constants.imageName)
        }
    }

}
