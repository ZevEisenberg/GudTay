// Generated using Sourcery 0.17.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT



//swiftlint:disable:previous vertical_whitespace

// MARK: - DoodleService
protocol DoodleServiceDelegate: AnyObject {
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
protocol DoodleViewDelegate: AnyObject {
    func doodleView(_ view: DoodleView, didNotify action: DoodleView.Action)
}

extension DoodleView {

    typealias ActionType = Action
    typealias Delegate = DoodleViewDelegate

    func notify(_ action: ActionType) {
        delegate?.doodleView(self, didNotify: action)
    }

}

// MARK: - DoodleViewModel
protocol DoodleViewModelDelegate: AnyObject {
    func doodleViewModel(_ component: DoodleViewModel, didNotify action: DoodleViewModel.Action)
}

extension DoodleViewModel {

    typealias ActionType = Action
    typealias Delegate = DoodleViewModelDelegate

    func notify(_ action: ActionType) {
        delegate?.doodleViewModel(self, didNotify: action)
    }

}
