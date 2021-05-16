import SideMenu
import SwiftIconFont
import UIKit

open class ScreenHelper {
    private unowned let screen: ScreenProtocol

    private var navItem: UIBarButtonItem?

    public init(_ screen: ScreenProtocol) {
        self.screen = screen

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationDidBecomeActiveNotification(_:)),
                                               name: UIApplication.willEnterForegroundNotification,
                                               object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func setupLeftMenuButton() {
        // Use customView to ensure UIBarButtonItem.view exists at all times or else the badge won't appear as we navigate
        // to other screens. See http://stackoverflow.com/questions/43641698/getting-frame-of-uibarbuttonitem-returns-nil
        navItem = GBarButtonItem()
//            .icon(GIcon(font: .fontAwesome, code: "bars"))
            .icon(GIcon(font: .materialIcon, code: "menu"))
            .onClick({
                self.leftMenuButtonPressed()
            })

        screen.controller.navigationItem.leftBarButtonItem = navItem
    }

    public func leftMenu(controller: UIViewController) {
        setupLeftMenuButton()
//
//        let menuLeftNavigationController = UISideMenuNavigationController(rootViewController: controller)
//        menuLeftNavigationController.leftSide = true
//
//        SideMenuManager.default.menuLeftNavigationController = menuLeftNavigationController
//        SideMenuManager.default.menuPresentMode = .viewSlideOut
//        SideMenuManager.default.menuFadeStatusBar = false
//
//        if let navigationController = screen.navigationController {
//            SideMenuManager.default.menuAddPanGestureToPresent(toView: navigationController.navigationBar)
//            SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: navigationController.view)
//        }

        let leftMenuNavigationController = SideMenuNavigationController(rootViewController: controller)
        SideMenuManager.default.leftMenuNavigationController = leftMenuNavigationController
    }

    @objc func leftMenuButtonPressed() {
        if let viewController = SideMenuManager.default.leftMenuNavigationController {
            screen.controller.present(viewController, animated: true, completion: nil)
        }
//        screen.controller.present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
    }

    // Made public so that it's accessible from GaniWeb
    public func viewWillAppear() {
//        updateBadge()
    }

    @objc fileprivate func applicationDidBecomeActiveNotification(_: Notification) {
//        updateBadge()
    }

//    private func updateBadge() {
//        // Can be nil since not all screens have nav menu.
//        navItem?.setBadge(text: UIApplication.shared.applicationIconBadgeNumber > 0 ? "!" : "")
//    }
}
