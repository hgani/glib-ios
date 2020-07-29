#if INCLUDE_MDLIBS

import MaterialComponents.MaterialTabs

class JsonView_TabBarV1: JsonView {
    private let tabBar = MTabBar()

    override func initView() -> UIView {
        tabBar
            .width(LayoutSize(rawValue: spec["width"].stringValue)!)
            .color(bg: UIColor(hex: spec["backgroundColor"].stringValue), text: UIColor(hex: spec["color"].stringValue))
            .alignment(spec["buttons"].arrayValue.count > 3 ? .leading : .justified)
            .onChange { _, item, _ in
                if let tabItem = item as? JsonView_TabBarItemV1, let onClick = tabItem.spec["onClick"].presence {
                    JsonAction.execute(spec: onClick, screen: self.screen, creator: nil)
                }
            }
//            .delegate(delegate, retain: true)

        spec["buttons"].arrayValue.forEach { (tab) in
            let tabBarItem = JsonView_TabBarItemV1(tab)
            tabBar.items.append(tabBarItem)
        }

        let selectedTab = tabBar.items.first(where: { (tab) -> Bool in
            if let tabItem = tab as? JsonView_TabBarItemV1, let onClick = tabItem.spec["onClick"].presence {
                return onClick["url"].stringValue == (screen as? JsonUiScreen)?.url
            }

            return false
        })

        if selectedTab != nil {
            tabBar.setSelectedItem(selectedTab, animated: false)
        }

        return tabBar
    }
}

class JsonView_TabBarItemV1: UITabBarItem {
    var spec: Json

    init(_ spec: Json) {
        self.spec = spec
        super.init()
        self.title = spec["text"].stringValue
        self.isEnabled = !spec["disabled"].boolValue
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

#endif
