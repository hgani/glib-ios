import UIKit

public class GApp {
    private static let info = (Bundle.main.infoDictionary ?? [:])
    public static let version = (info["CFBundleShortVersionString"] as? String) ?? "Unknown"

    public var navigationController: GNavigationController!
    public var window: UIWindow!

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

//        window.backgroundColor = .white
//        window.makeKeyAndVisible()

        return self
    }

//    @available(iOS 13.0, *)
//    public func withNav(_ navigationController: GNavigationController, scene: UIWindowScene) -> Self {
//        RobotoFonts.loadAll()
//
//        // Uncomment to debug
////        #if DEBUG
////        GLog.t("Font family: \(UIFont.familyNames)")
////        for fontName in UIFont.fontNames(forFamilyName: "Roboto") {
////            GLog.t("Font name: \(fontName)")
////        }
////        #endif
//
//        self.navigationController = navigationController
//
//        window = UIWindow(windowScene: scene)
//        window.rootViewController = navigationController
//
////        window.backgroundColor = .white
////        window.makeKeyAndVisible()
//
//        return self
//    }
}
