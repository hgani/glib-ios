#if INCLUDE_MDLIBS

import MaterialComponents.MaterialTabs

class JsonView_TabBarV1: JsonView {
    private let tabBar = MTabBar()

    override func initView() -> UIView {
//        let delegate = Delegate(view: self)

        tabBar
            .width(LayoutSize(rawValue: spec["width"].stringValue)!)
            .color(bg: UIColor(hex: spec["backgroundColor"].stringValue), text: UIColor(hex: spec["color"].stringValue))
            .alignment(spec["tabButtons"].arrayValue.count > 3 ? .leading : .justified)
            .onChange { _, item, _ in
                if let onClick = (item as! JsonView_TabBarItemV1).spec["onClick"].presence {
                    JsonAction.execute(spec: onClick, screen: self.screen, creator: nil)
                }
            }
//            .delegate(delegate, retain: true)

        spec["tabButtons"].arrayValue.forEach { (tab) in
            let tabBarItem = JsonView_TabBarItemV1(tab)
            tabBar.items.append(tabBarItem)
        }

        let selectedTab = tabBar.items.first(where: { (tab) -> Bool in
            if let onClick = (tab as! JsonView_TabBarItemV1).spec["onClick"].presence {
                return onClick["url"].stringValue == (screen as! JsonUiScreen).getUrl()
            }

            return false
        })

        if selectedTab != nil {
            tabBar.setSelectedItem(selectedTab, animated: false)
        }

        return tabBar
    }

//    class Delegate: NSObject, MDCTabBarDelegate {
//        private let view: JsonView_TabBarV1
//
//        init(view: JsonView_TabBarV1) {
//            self.view = view
//        }
//
//        func tabBar(_ tabBar: MDCTabBar, didSelect item: UITabBarItem) {
////            if !item.isEnabled {
////                return
////            }
//
//            if let onClick = (item as! JsonView_TabBarItemV1).spec["onClick"].presence {
//                JsonAction.execute(spec: onClick, screen: view.screen, creator: nil)
//            }
//        }
//
//        func tabBar(_ tabBar: MDCTabBar, shouldSelect item: UITabBarItem) -> Bool {
//            return item.isEnabled
//        }
//    }
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
