//
//  DoodleView.swift
//  GudTay
//
//  Created by Zev Eisenberg on 7/23/17.
//  Copyright © 2017 Zev Eisenberg. All rights reserved.
//

// Code modified from https://techblog.badoo.com/blog/2015/06/15/lets-build-freehand-drawing-in-ios-part-1/

import Anchorage

extension DoodleView: Actionable {
    enum Action {
        case showClearPrompt(sourceButton: UIButton, completion: (_ clear: Bool) -> Void)

        /// Not used for transient changes. Used to send completed images once touches end.
        case imageUpdateCommitted(UIImage)
    }
}

final class DoodleView: GridView {

    // Public Properties

    weak var delegate: DoodleViewDelegate?

    // Private Properties

    private let viewModel: DoodleViewModel
    private let imageView = UIImageView()

    override init(frame: CGRect) {
        viewModel = DoodleViewModel(size: frame.size, persistence: .onDisk)

        super.init(frame: frame)

        viewModel.newImageCallback = { [weak self] image, updateKind in
            DispatchQueue.main.async {
                self?.imageView.image = image
                if updateKind == .committedLocally {
                    self?.notify(.imageUpdateCommitted(image))
                }
            }
        }

        // View Hierarchy

        contentView.addSubview(imageView)

        // Layout

        imageView.edgeAnchors == edgeAnchors

    }

    override func layoutSubviews() {
        viewModel.size = bounds.size
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

}
