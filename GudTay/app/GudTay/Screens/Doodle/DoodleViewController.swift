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

    override func loadView() {
        view = doodleView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        doodleView.delegate = self
        service.delegate = self

        let modeSwitch = UISwitch()

        let clearButton = UIButton()
        clearButton.setImage(Asset.Doodle.gun.image, for: .normal)

        // View Hierarchy
        doodleView.contentView.addSubview(modeSwitch)
        doodleView.contentView.addSubview(clearButton)

        // Layout

        modeSwitch.trailingAnchor == doodleView.trailingAnchor

        clearButton.topAnchor == modeSwitch.bottomAnchor + 15
        clearButton.trailingAnchor == doodleView.trailingAnchor
        clearButton.bottomAnchor == doodleView.bottomAnchor
        clearButton.layoutIfNeeded()

        // Setup

        clearButton.addTarget(self, action: #selector(clearTapped(sender:)), for: .touchUpInside)
        modeSwitch.addTarget(self, action: #selector(modeSwitched(sender:)), for: .valueChanged)

        modeSwitch.isSelected = true
    }

}

// MARK: - Actions

private extension DoodleViewController {

    @objc func clearTapped(sender: UIButton) {
        showClearPrompt(from: sender)
    }

    @objc func modeSwitched(sender: UISwitch) {
        doodleView.setDrawing(enabled: sender.isOn)
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
