import SwiftyJSON

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
        if let wrapper = JsonView_Panels_VerticalV1(spec, screen).createView() as? GVerticalPanel {
            panel.addView(wrapper.width(.matchParent))
        }
    }

    private static func initNavBar(spec: Json, screen: GScreen) {
        let buttons = spec["rightNavButtons"].arrayValue.map { json -> GBarButtonItem in
            let item = GBarButtonItem()
                .onClick({
                    JsonAction.execute(spec: json["onClick"], screen: screen, creator: nil)
                })
            if let iconName = json["icon"]["materialName"].string {
                item.icon(GIcon(font: .materialIcon, code: iconName))
            }
            return item
        }

        screen.rightBarButtons(items: buttons)

        if let leftDrawer = spec["leftDrawer"].presence {
            let menuController = JsonUiMenuNavController(leftDrawer, screen)
            screen.leftMenu(controller: menuController)
        }
    }
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
        if let rows = spec["rows"].presence {
            rows.arrayValue.forEach { (row) in
                if let title = row["text"].string {
                    let item = MenuItem(title: title).onClick {
                        JsonAction.execute(spec: row["onClick"], screen: self.screen, creator: nil)
                    }
                    if let iconName = row["icon"]["materialName"].string {
                        item.icon(GIcon(font: .materialIcon, code: iconName))
                    }
                    menu.add(item)
                }
            }
        }

//        menu.add(MenuItem(title: "TODO").icon(GIcon(font: .materialIcon, code: "home")).onClick {
//            self.launch.alert("TODO")
//        })

//        #if DEBUG
//        menu.add(MenuItem(title: "Diagnostics").screen(JsonUiScreen(path: "/app_diagnostics.json")))
//        #endif
    }
}

class ScrollableView {
    static var items = [UIView]()

    static func delegateCall(scrollView: UIScrollView, useContentOffset: Bool = false) {
        for view in items {
            if let fab = view as? MFab {
                fab.frame.origin.y = scrollView.bounds.size.height - 76
                if useContentOffset {
                    fab.frame.origin.y = fab.frame.origin.y + scrollView.contentOffset.y
                }
            }
        }
    }
}
