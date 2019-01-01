// Generated using Sourcery 0.15.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT



//swiftlint:disable:previous vertical_whitespace

// MARK: - DoodleService
protocol DoodleServiceDelegate: class {
    func doodleService(_ component: DoodleService, didNotify action: DoodleService.Action)
}

extension DoodleService {

    typealias ActionType = Action
    typealias Delegate = DoodleServiceDelegate

    func notify(_ action: ActionType) {
        delegate?.doodleService(self, didNotify: action)
    }

}

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
