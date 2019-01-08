//
//  DoodleViewController.swift
//  GudTay
//
//  Created by Zev Eisenberg on 12/31/18.
//

import Anchorage
import Swiftilities
import UIKit

final class DoodleViewController: UIViewController {

    // Public Properties

    let doodleView = DoodleView()

    // Private Properties

    private let service = DoodleService()
    private let modeToggle = ToggleButton()

    override func loadView() {
        view = doodleView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        doodleView.delegate = self
        doodleView.viewModel.delegate = self // sorry, Demeter
        service.delegate = self

        let clearButton = UIButton()
        clearButton.setImage(Asset.Doodle.gun.image, for: .normal)

        // View Hierarchy
        doodleView.contentView.addSubview(modeToggle)
        doodleView.contentView.addSubview(clearButton)

        // Layout

        modeToggle.trailingAnchor == doodleView.trailingAnchor - 5

        clearButton.topAnchor == modeToggle.bottomAnchor + 15
        clearButton.trailingAnchor == doodleView.trailingAnchor
        clearButton.bottomAnchor == doodleView.bottomAnchor
        clearButton.layoutIfNeeded()

        // Setup

        modeToggle.primaryImage = Asset.Doodle.marker.image
        modeToggle.secondaryImage = Asset.Doodle.eraser.image

        clearButton.addTarget(self, action: #selector(clearTapped(sender:)), for: .touchUpInside)
        modeToggle.addTarget(self, action: #selector(modeToggled(sender:)), for: .valueChanged)

        modeToggle.sizeToFit()
    }

}

// MARK: - Actions

private extension DoodleViewController {

    @objc func clearTapped(sender: UIButton) {
        showClearPrompt(from: sender)
    }

    @objc func modeToggled(sender: ToggleButton) {
        doodleView.setDrawing(enabled: sender.mode == .primary)
    }

}

private extension DoodleViewController {

    func showClearPrompt(from sourceButton: UIButton) {
        // verbs via http://calvinandhobbes.wikia.com/wiki/Spaceman_Spiff#Spiff.27s_Weaponry_and_Equipment
        let verbs = ["Shake-n’-Bake", "Medium Well", "Deep Fat-fry", "Frappe", "Liquefy"]
        guard let verb = verbs.random else {
            preconditionFailure("Accessing random element from collection literal should never be nil")
        }

        let alert = UIAlertController(title: "Zap drawing at \(verb) setting?", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        alert.addAction(UIAlertAction(title: "\(verb.localizedUppercase)!", style: .destructive, handler: { [weak self] _ in
            self?.doodleView.clearDrawing()
        }))

        show(alert, sender: self)
        alert.popoverPresentationController?.sourceView = sourceButton
        alert.popoverPresentationController?.sourceRect = sourceButton.bounds
    }

}

extension DoodleViewController: DoodleViewModel.Delegate {

    func doodleViewModel(_ component: DoodleViewModel, didNotify action: DoodleViewModel.Action) {
        switch action {
        case .changedMode(let mode):
            modeToggle.setMode(mode == .drawing ? .primary : .secondary, animated: true)
        }
    }

}

extension DoodleViewController: DoodleView.Delegate {

    func doodleView(_ view: DoodleView, didNotify action: DoodleView.Action) {
        switch action {
        case .imageUpdateCommitted(let image):
            service.sendImage(image)
        case .showClearPrompt(let sourceButton, let completion):
            // verbs via http://calvinandhobbes.wikia.com/wiki/Spaceman_Spiff#Spiff.27s_Weaponry_and_Equipment
            let verbs = ["Shake-n’-Bake", "Medium Well", "Deep Fat-fry", "Frappe", "Liquefy"]
            guard let verb = verbs.random else {
                preconditionFailure("Accessing random element from collection literal should never be nil")
            }

            let alert = UIAlertController(title: "Zap drawing at \(verb) setting?", message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
                completion(false)
            }))

            alert.addAction(UIAlertAction(title: "\(verb.localizedUppercase)!", style: .destructive, handler: { _ in
                completion(true)
            }))

            show(alert, sender: self)
            alert.popoverPresentationController?.sourceView = sourceButton
            alert.popoverPresentationController?.sourceRect = sourceButton.bounds
        }
    }

}

extension DoodleViewController: DoodleService.Delegate {

    func doodleService(_ component: DoodleService, didNotify action: DoodleService.Action) {
        switch action {
        case .connectedDevicesChanged(let deviceNames):
            Log.info("now connected to devices: \(deviceNames)")
        case .receivedImage(let image):
            doodleView.updateImage(image, kind: .fromNetwork)
        }
    }

}
