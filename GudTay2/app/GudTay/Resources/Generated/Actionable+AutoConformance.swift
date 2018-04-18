// Generated using Sourcery 0.12.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT



//swiftlint:disable:previous vertical_whitespace

// MARK: - DoodleView
protocol DoodleViewDelegate: class {
    func doodleView(_ view: DoodleView, didNotify action: DoodleView.Action)
}

extension DoodleView {

    typealias ActionType = Action
    typealias Delegate = DoodleViewDelegate

    func notify(_ action: ActionType) {
        delegate?.doodleView(self, didNotify: action)
    }

}
