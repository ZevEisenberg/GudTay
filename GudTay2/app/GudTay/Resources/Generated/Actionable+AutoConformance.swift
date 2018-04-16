// Generated using Sourcery 0.12.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT



//swiftlint:disable:previous vertical_whitespace

// MARK: - OnboardingPageViewController
protocol OnboardingPageViewControllerDelegate: class {
    func onboardingPageViewController(_ vc: OnboardingPageViewController, didNotify action: OnboardingPageViewController.Action)
}

extension OnboardingPageViewController {

    typealias ActionType = Action
    typealias Delegate = OnboardingPageViewControllerDelegate

    func notify(_ action: ActionType) {
        delegate?.onboardingPageViewController(self, didNotify: action)
    }

}
