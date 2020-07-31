import SwiftyJSON
//import MaterialComponents.MaterialTabs

public class JsonUi {
    private static var moduleName: String?

    static func register(_ buildConfig: BuildConfig) {
        if let type = type(of: buildConfig) as? AnyClass {
            moduleName = moduleName(from: type)
        }
    }

    private static func moduleName(from type: AnyClass) -> String {
        let object = NSStringFromClass(type) as NSString
        return object.components(separatedBy: ".").first!
    }

    private static func replaceNamespace(of str: String, with namespace: String) -> String {
        let libModule = moduleName(from: self)
        return str.replace(regex: "^\(libModule).", with: "\(namespace).")
    }

    static func loadClass(name: String, type: AnyClass) -> Swift.AnyClass? {
        let typeName = NSStringFromClass(type)
        let className = name
            .components(separatedBy: "/")
            // Don't use .capitalized() because that converts "showAlert" to "Showalert"
            .map { $0.prefix(1).uppercased() + $0.dropFirst() }
            .joined(separator: "_")
            .replacingOccurrences(of: "-v", with: "V")
        let nameWithLibPrefix = "\(typeName)_\(className)"
//        GLog.t("Loading \(nameWithLibPrefix) from \(name) ...")
        if let clazz = NSClassFromString(nameWithLibPrefix) {
            return clazz
        }

        if let replacement = moduleName {
            let nameWithAppPrefix = replaceNamespace(of: nameWithLibPrefix, with: replacement)
//            GLog.t("Loading \(nameWithAppPrefix) from \(name) ...")
            return NSClassFromString(nameWithAppPrefix)
        }

        return nil
    }

    public static func parseResponse(_ spec: Json, screen: UIViewController) {
        JsonAction.execute(spec: spec["onResponse"], screen: screen, creator: nil)
    }

    public static func parseScreenContent(_ spec: Json, screen: GScreen) {
        initVerticalPanel(screen.container.header, spec: spec["header"], screen: screen)
        initVerticalPanel(screen.container.content, spec: spec["body"], screen: screen)
        initVerticalPanel(screen.container.footer, spec: spec["footer"], screen: screen)
        if let navMenu = spec["navMenu"].presence {
            initBottomTabBar(screen.container.footer, spec: navMenu, screen: screen)
        }

        JsonAction.execute(spec: spec["onLoad"], screen: screen, creator: nil)

        // TODO: Remove (deprecated)
        initVerticalPanel(screen.container.content, spec: spec["content"], screen: screen)
    }

    public static func parseEntireScreen(_ spec: Json, screen: GScreen) {
        screen.title = spec["title"].string

        parseScreenContent(spec, screen: screen)
        initNavBar(spec: spec, screen: screen)
    }

    public static func parseContentScreen(_ spec: Json, screen: GScreen) {
        parseScreenContent(spec, screen: screen)
    }

    private static func initVerticalPanel(_ panel: GVerticalPanel, spec: Json, screen: GScreen) {
        if let wrapper = JsonViewDefaultPanel(spec, screen).view() as? GVerticalPanel {
            panel.addView(wrapper.width(.matchParent))
        }
    }

    private static func initNavBar(spec: Json, screen: GScreen) {
        let buttons = spec["rightNavButtons"].arrayValue.map { json -> GBarButtonItem in
            let customView = GLabel()
                .specs(.link)
                .onClick({ _ in
                    JsonAction.execute(spec: json["onClick"], screen: screen, creator: nil)
                })
            JsonView_IconV1.update(view: customView, spec: json["icon"])
            return GBarButtonItem(customView: customView)
        }

        screen.rightBarButtons(items: buttons)

        if let leftDrawer = spec["leftDrawer"].presence {
            let menuController = JsonUiMenuNavController(leftDrawer, screen)
            screen.leftMenu(controller: menuController)
        }
    }

    public static func initBottomTabBar(_ panel: GVerticalPanel, spec: Json, screen: GScreen) {
        #if INCLUDE_MDLIBS

        let tabBar = MTabBar()

        tabBar
            .width(.matchParent)
            .color(bg: .white, text: .gray)
            .alignment(.leading)
            .onChange { _, item, _ in
                if let tabItem = item as? JsonView_TabBarItemV1, let onClick = tabItem.spec["onClick"].presence {
                    JsonAction.execute(spec: onClick, screen: screen, creator: nil)
                }
            }

        spec["rows"].arrayValue.forEach { (tab) in
            let tabBarItem = JsonView_TabBarItemV1(tab)
            tabBar.items.append(tabBarItem)
        }

        let selectedTab = tabBar.items.first(where: { (item) -> Bool in
            if let tabItem = item as? JsonView_TabBarItemV1, let onClick = tabItem.spec["onClick"].presence {
                return onClick["url"].stringValue == (screen as? JsonUiScreen)?.url
            }

            return false
        })

        if selectedTab != nil {
            tabBar.setSelectedItem(selectedTab, animated: false)
        }

        panel.addView(tabBar)

        #endif
    }

//    class Delegate: NSObject, MDCTabBarDelegate {
//        private let view: MTabBar
//        private let screen: GScreen
//
//        init(view: MTabBar, screen: GScreen) {
//            self.view = view
//            self.screen = screen
//        }
//
//        func tabBar(_ tabBar: MDCTabBar, didSelect item: UITabBarItem) {
//            if !item.isEnabled {
//                return
//            }
//
//            if let onClick = (item as! JsonView_TabBarItemV1).spec["onClick"].presence {
//                JsonAction.execute(spec: onClick, screen: screen, creator: nil)
//            }
//        }
//    }
}

class JsonUiMenuNavController: MenuNavController {
    var spec: JSON
    var screen: GScreen

    public required init(_ spec: Json, _ screen: GScreen) {
        self.spec = spec
        self.screen = screen
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func initMenu(_ menu: Menu) {
        spec["rows"].arrayValue.forEach { (row) in
            let item = MenuItem().onClick {
                JsonAction.execute(spec: row["onClick"], screen: self.screen, creator: nil)
            }

            if let title = row["text"].string {
                item.title(title)
            }

            if let spec = row["icon"].presence {
                item.iconSpec(spec)
            }

            menu.add(item)
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let header = spec["header"].presence {
            let panel = GVerticalPanel()
            header["childViews"].arrayValue.forEach { viewSpec in
                if let jsonView = JsonView.create(spec: viewSpec, screen: screen) {
                    panel.append(jsonView.view())
                }
            }
            return panel
        }
        return nil
    }
}

class ScrollableView {
    // TODO: Need to use weak ref to avoid leaks
    private static var items = [UIView]()

    static func register(fab: UIView) {
        items.append(fab)
    }

    // TODO: Need a better solution. Currently, FAB doesn't show if the screen never gets scrolled.]
    //
    // Consider deprecating support for FAB inside scroll view, i.e. FAB has to be specified outside
    // scroll view, just like when it needs to co-exist with table view.
    // - The problem with this constraint is that we can't have FAB inside a form, which means that
    //   FAB can't have submit action.
    // - This may not be a bad thing given that we want to phase out submit action in favor of
    //   submit button because submit buttons work better for the web
    static func delegateCall(scrollView: UIScrollView, useContentOffset: Bool = false) {
        for view in items {
            #if INCLUDE_MDLIBS
            if let fab = view as? MFloatingButton {
                fab.frame.origin.y = scrollView.bounds.size.height - 76
                if useContentOffset {
                    fab.frame.origin.y += scrollView.contentOffset.y
                }
            }
            #endif
        }
    }
}
