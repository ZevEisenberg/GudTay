//
//  DoodleView.swift
//  GudTay
//
//  Created by Zev Eisenberg on 7/23/17.
//  Copyright © 2017 Zev Eisenberg. All rights reserved.
//

// Code modified from https://techblog.badoo.com/blog/2015/06/15/lets-build-freehand-drawing-in-ios-part-1/

import Anchorage
import UIKit

protocol DoodleViewDelegate: AnyObject {

    func doodleView(_ doodleView: DoodleView, did action: DoodleView.Action)
}

extension DoodleView {

    typealias Delegate = DoodleViewDelegate

    enum Action {
        case showClearPrompt(sourceButton: UIButton, completion: (_ clear: Bool) -> Void)

        /// Not used for transient changes. Used to send completed images once touches end.
        case imageUpdateCommitted(UIImage)
    }
}

final class DoodleView: GridView {

    // Public Properties

    weak var delegate: Delegate?
    let viewModel: DoodleViewModel

    // Private Properties

    private let imageLayer = CALayer()

    override init(frame: CGRect) {
        viewModel = DoodleViewModel(size: frame.size, persistence: .onDisk)

        super.init(frame: frame)

        contentView.layer.addSublayer(imageLayer)

        viewModel.newImageCallback = { [weak self] cgImage, updateKind in
            DispatchQueue.main.async {
                self?.handleUpdate(withImage: cgImage, kind: updateKind)
            }
        }
    }

    override func layoutSubviews() {
        viewModel.size = bounds.size
        imageLayer.bounds = bounds
        imageLayer.anchorPoint = .zero
        imageLayer.position = .zero
        super.layoutSubviews()
    }

    override func didMoveToWindow() {
        super.didMoveToWindow()
        viewModel.loadPersistedImage()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        viewModel.startAt(touches.first!.location(in: self))
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        viewModel.continueTo(touches.first!.location(in: self))
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        viewModel.endAt(touches.first!.location(in: self))
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        viewModel.endAt(touches.first!.location(in: self))
    }

}

// MARK: - Public Methods

extension DoodleView {

    func updateImage(_ newImage: UIImage, kind: DoodleViewModel.ImageUpdateKind) {
        viewModel.updateImage(newImage, kind: kind)
    }

    func clearDrawing() {
        viewModel.clearDrawing()
    }

    func setDrawing(enabled: Bool) {
        viewModel.currentMode = enabled ? .drawing : .erasing
    }

}

// MARK: - Private Methods

private extension DoodleView {

    func handleUpdate(withImage cgImage: CGImage, kind updateKind: DoodleViewModel.ImageUpdateKind) {
        dispatchPrecondition(condition: .onQueue(.main))
        CATransaction.performWithoutAnimation {
            self.imageLayer.contents = cgImage
        }
        if updateKind == .committedLocally {
            self.delegate?.doodleView(self, did: .imageUpdateCommitted(UIImage(cgImage: cgImage)))
        }
    }

}
