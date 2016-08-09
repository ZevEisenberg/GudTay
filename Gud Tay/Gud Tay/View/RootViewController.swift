//
//  RootViewController.swift
//  Gud Tay
//
//  Created by Zev Eisenberg on 7/24/16.
//  Copyright © 2016 Zev Eisenberg. All rights reserved.
//

import UIKit
import Anchorage

final class RootViewController: UIViewController {

    private let mbtaViewController = MBTAViewController(viewModel: MBTAViewModel(serviceType: MBTAService.self))
    private let mainStackView: UIStackView = {
        let stackView = UIStackView(axId: "mainStackView")
        stackView.axis = .vertical
        stackView.alignment = .fill
        return stackView
    }()

    private let errorTextView: UITextView = {
        let textView = UITextView(axId: "errorTextView")
        textView.font = UIFont(name: "Menlo", size: 12)
        textView.isEditable = false
        textView.alwaysBounceVertical = true
        return textView
    }()

    private var errorMessages = ["Starting up at \(Date())"]

    private let weatherPlaceholderView = UIView(axId: "weatherPlaceholderView")

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        mbtaViewController.errorHandler = { [weak self] message in
            self?.errorMessages.append("\(Date()) - \(message)")
            if self?.errorMessages.count > 200 {
                self?.errorMessages.removeFirst()
            }
            self?.updateErrorDisplay()
        }
        updateErrorDisplay()
    }

    @available(*, unavailable) required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = UIView(axId: "rootViewController.view")
        view.backgroundColor = .white

        view.addSubview(mainStackView)
        mainStackView.addArrangedSubview(mbtaViewController.view)
        mainStackView.addArrangedSubview(weatherPlaceholderView)

        weatherPlaceholderView.addSubview(errorTextView)
        errorTextView.edgeAnchors == weatherPlaceholderView.edgeAnchors
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        mainStackView.horizontalAnchors == view.horizontalAnchors
        mainStackView.topAnchor == topLayoutGuide.bottomAnchor
        mainStackView.bottomAnchor == bottomLayoutGuide.topAnchor
        weatherPlaceholderView.heightAnchor == view.heightAnchor * 0.2
        weatherPlaceholderView.backgroundColor = #colorLiteral(red: 0.8152596933, green: 0.9053656769, blue: 0.9693969488, alpha: 1)

        let shareButton = UIButton(type: .system)
        shareButton.setTitle("Send Logs", for: .normal)
        shareButton.addTarget(self, action: #selector(RootViewController.shareButtonTapped(sender:)), for: .touchUpInside)
        view.addSubview(shareButton)
        shareButton.trailingAnchor == view.trailingAnchor - 10
        shareButton.bottomAnchor == view.bottomAnchor - 10
        shareButton.backgroundColor = .white

        let clearButton = UIButton(type: .system)
        clearButton.setTitle("Clear", for: .normal)
        clearButton.addTarget(self, action: #selector(RootViewController.clearButtonTapped(sender:)), for: .touchUpInside)
        view.addSubview(clearButton)
        clearButton.trailingAnchor == shareButton.leadingAnchor - 10
        clearButton.firstBaselineAnchor == shareButton.firstBaselineAnchor
        clearButton.backgroundColor = .white
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

}

private extension RootViewController {

    @objc func shareButtonTapped(sender: UIButton) {
        let shareSheet = UIActivityViewController(activityItems: [errorTextView.text], applicationActivities: nil)
        show(shareSheet, sender: self)
        shareSheet.modalPresentationStyle = .popover
        shareSheet.popoverPresentationController?.sourceView = sender
        shareSheet.popoverPresentationController?.sourceRect = sender.bounds
    }

    @objc func clearButtonTapped(sender: UIButton) {
        errorMessages = ["Starting up at \(Date())"]
        updateErrorDisplay()
    }

    func updateErrorDisplay() {
        errorTextView.text = errorMessages.joined(separator: "\n\n")
        let range = NSRange(location: errorTextView.text.characters.count - 2, length: 1)
        errorTextView.scrollRangeToVisible(range)
    }

}
