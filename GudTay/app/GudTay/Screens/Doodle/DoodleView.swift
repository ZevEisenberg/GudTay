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

        viewModel.newImageCallback = { [weak self] image in
            DispatchQueue.main.async {
                self?.imageView.image = image
            }
        }

        let clearButton = UIButton()
        clearButton.setImage(Asset.gun.image, for: .normal)

        // View Hierarchy

        contentView.addSubview(imageView)
        contentView.addSubview(clearButton)

        // Layout

        imageView.edgeAnchors == edgeAnchors
        clearButton.trailingAnchor == trailingAnchor
        clearButton.bottomAnchor == bottomAnchor

        // Setup

        clearButton.addTarget(self, action: #selector(clearTapped(sender:)), for: .touchUpInside)
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

// MARK: - Actions

private extension DoodleView {

    @objc func clearTapped(sender: UIButton) {
        notify(.showClearPrompt(sourceButton: sender, completion: { [weak self] clear in
            if clear {
                self?.viewModel.clearDrawing()
            }
        }))
    }

}
