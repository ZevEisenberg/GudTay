//
//  DoodleView.swift
//  Gud Tay
//
//  Created by Cheryl Pedersen on 7/23/17.
//  Copyright © 2017 Zev Eisenberg. All rights reserved.
//

final class DoodleView: GridView {

    // Private Properties

    private var lineColor = UIColor.black
    private var lineWidth: CGFloat = 5.0

    fileprivate var path = UIBezierPath()

    override init(frame: CGRect) {
        super.init(frame: frame)

        let pan = UIPanGestureRecognizer(target: self, action: #selector(panned(sender:)))
        addGestureRecognizer(pan)
    }

    override func draw(_ rect: CGRect) {
        lineColor.setStroke()
        path.lineWidth = lineWidth
        path.lineCapStyle = .round
        path.lineJoinStyle = .round
        path.stroke()
    }

}

// MARK: - Actions

private extension DoodleView {

    @objc func panned(sender: UILongPressGestureRecognizer) {
        let point = sender.location(in: self)
        switch sender.state {
        case .began:
            startAt(point)
        case .changed:
            continueTo(point)
        case .ended, .cancelled:
            endAt(point)
        default:
            fatalError("That's not a thing: \(sender.state)")
        }
    }

}

// MARK: - Private

private extension DoodleView {

    func startAt(_ point: CGPoint) {
        path.move(to: point)
    }

    func continueTo(_ point: CGPoint) {
        path.addLine(to: point)
        setNeedsDisplay()
    }

    func endAt(_ point: CGPoint) {
        // no-op
    }

}
