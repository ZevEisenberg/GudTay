//
//  LogViewController.swift
//  GudTay
//
//  Created by Zev Eisenberg on 8/17/16.
//  Copyright © 2016 Zev Eisenberg. All rights reserved.
//

import Anchorage
import Services

final class LogViewController: UIViewController {

    private let errorTextView: UITextView = {
        let textView = UITextView(axId: "errorTextView")
        textView.font = UIFont(name: "Menlo", size: 12)
        textView.isEditable = false
        textView.alwaysBounceVertical = true
        return textView
    }()

    init() {
        super.init(nibName: nil, bundle: nil)

        title = "Logs"
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(LogViewController.doneTapped(sender:)))
        navigationItem.leftBarButtonItem = doneButton

        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(LogViewController.shareTapped(sender:)))
        let clearButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(LogViewController.trashTapped(sender:)))
        navigationItem.rightBarButtonItems = [clearButton, shareButton]
    }

    @available(*, unavailable) required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(errorTextView)
        errorTextView.edgeAnchors == view.edgeAnchors
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateErrorDisplay()
    }

}

private extension LogViewController {

    @objc func doneTapped(sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    @objc func shareTapped(sender: UIBarButtonItem) {
        guard let errorText = errorTextView.text else { return }
        let shareSheet = UIActivityViewController(activityItems: [errorText], applicationActivities: nil)
        present(shareSheet, animated: true, completion: nil)
        shareSheet.modalPresentationStyle = .popover
        shareSheet.popoverPresentationController?.barButtonItem = sender
    }

    @objc func trashTapped(sender: UIBarButtonItem) {
        LogService.clear()
        updateErrorDisplay()
    }

    func updateErrorDisplay() {
        errorTextView.text = LogService.messages.joined(separator: "\n\n")
        let range = NSRange(location: errorTextView.text.count - 2, length: 1)
        errorTextView.scrollRangeToVisible(range)
    }

}
