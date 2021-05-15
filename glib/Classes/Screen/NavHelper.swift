import MessageUI
import UIKit

open class NavHelper {
    private let navController: UINavigationController!
    private var showBar = true

    public convenience init(_ screen: ScreenProtocol) {
        self.init(navController: screen.navigationController!)
    }

    init(navController: UINavigationController) {
        self.navController = navController
    }

    public func hideBar() {
        showBar = false
    }

    public func hideBackButton() {
//        if let screen = navController.topViewController as? ScreenProtocol {
        if let screen = navController.topViewController as? GScreen {
            screen.navigationItem.setHidesBackButton(true, animated: false)
        }
    }

    public func color(bg: UIColor, text: UIColor) {
        navController.navigationBar.barTintColor = bg
        navController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: text]
        navController.navigationBar.tintColor = text // For built-in back button
    }

    public func viewWillAppear() {
        navController.setNavigationBarHidden(!showBar, animated: false)
    }

    @discardableResult
    public func backToHome(animated: Bool = true) -> Self {
        navController.popToRootViewController(animated: animated)
        return self
    }

    public func refresh() {
        // TODO: Remove ScreenProtocol once we've migrated away from eureka
        if let screen = navController.topViewController as? ScreenProtocol {
//        if let screen = navController.topViewController as? GScreen {
            screen.onRefresh()
        }
    }

    public func push(_ controller: UIViewController, animated: Bool = true) {
        navController.pushViewController(controller, animated: animated)
    }

    public func popAndPush(_ controller: UIViewController, animated: Bool = true) {
        // See http://stackoverflow.com/questions/6872852/popping-and-pushing-view-controllers-in-same-action
        var vcArray = navController.viewControllers
        vcArray.removeLast()
        vcArray.append(controller)
        navController.setViewControllers(vcArray, animated: animated)
    }

    @discardableResult
    public func pop(animated: Bool = true) -> Self {
        navController.popViewController(animated: animated)
        return self
    }

    public func previousScreen() -> UIViewController? {
        let length = navController.viewControllers.count
        let previousViewController = length >= 2 ? navController.viewControllers[length - 1] : nil
        return previousViewController
    }

    public func isRoot() -> Bool {
        return navController.viewControllers.count <= 1
    }
}
