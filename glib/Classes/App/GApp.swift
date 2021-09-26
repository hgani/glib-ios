import UIKit

public class GApp {
    private static let info = (Bundle.main.infoDictionary ?? [:])
    public static let version = (info["CFBundleShortVersionString"] as? String) ?? "Unknown"

    public var navigationController: GNavigationController!
    public var window: UIWindow!
    public var screenDelegate: GScreenDelegate!

    public static let instance = GApp()

    // TODO: Deprecated from iOS13 onwards
    public func withOldNav(_ navigationController: GNavigationController) -> Self {
        RobotoFonts.loadAll()

        // Uncomment to debug
//        #if DEBUG
//        GLog.t("Font family: \(UIFont.familyNames)")
//        for fontName in UIFont.fontNames(forFamilyName: "Roboto") {
//            GLog.t("Font name: \(fontName)")
//        }
//        #endif

        self.navigationController = navigationController

        window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = navigationController

        return self
    }

    @available(iOS 13.0, *)
    public func withNav(_ navigationController: GNavigationController,
                        scene: UIWindowScene,
                        screenDelegate: GScreenDelegate) -> Self {
        RobotoFonts.loadAll()

        self.screenDelegate = screenDelegate

        // Uncomment to debug
//        #if DEBUG
//        GLog.t("Font family: \(UIFont.familyNames)")
//        for fontName in UIFont.fontNames(forFamilyName: "Roboto") {
//            GLog.t("Font name: \(fontName)")
//        }
//        #endif

        self.navigationController = navigationController

        window = UIWindow(windowScene: scene)
        window.rootViewController = navigationController

        #if INCLUDE_IAP

        JsonAction_Iap_InitiatePurchase.initOnAppLaunch()
        
        #endif

        return self
    }
    
    #if INCLUDE_FIREBASE
    
    public func handleNotificationClick(response: UNNotificationResponse) {
        // See https://firebase.google.com/docs/cloud-messaging/ios/receive
        let userInfo = response.notification.request.content.userInfo
        
        if let path = userInfo["window_open_path"] as? String {
            navigationController.pushViewController(JsonUiScreen(path: path, hideBackButton: true), animated: false)
        } else {
            GLog.w("Invalid notification data type")
        }
    }
    
    #endif
}
