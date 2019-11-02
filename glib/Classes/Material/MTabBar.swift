#if INCLUDE_UILIBS

import MaterialComponents.MaterialTabs

open class MTabBar: MDCTabBar {
    private var helper: ViewHelper!
//    private var retainedRef: MDCTabBarDelegate?
    private var onChange: ((MTabBar, UITabBarItem, Int) -> Void)?

    public init() {
        super.init(frame: .zero)
        initialize()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }

    private func initialize() {
        helper = ViewHelper(self)

        self.delegate = self
    }

    public func width(_ width: Int) -> Self {
        helper.width(width)
        return self
    }

    public func width(_ width: LayoutSize) -> Self {
        helper.width(width)
        return self
    }

    public func height(_ height: Int) -> Self {
        helper.height(height)
        return self
    }

    public func height(_ height: LayoutSize) -> Self {
        helper.height(height)
        return self
    }

    @discardableResult
    public func color(bg: UIColor?, text: UIColor? = nil) -> Self {
        if let bgColor = bg {
            backgroundColor = bgColor
        }
        if let textColor = text {
            setTitleColor(textColor, for: .normal)
            setTitleColor(textColor.muted(), for: .selected)
        }
        return self
    }

//    public func delegate(_ delegate: MDCTabBarDelegate, retain: Bool = false) -> Self {
//        self.delegate = delegate
//        if retain {
//            retainedRef = delegate
//        }
//        return self
//    }

    @discardableResult
    public func alignment(_ align: MDCTabBarAlignment) -> Self {
        self.alignment = align
        return self
    }

    // Use block instead of selector from now on. See https://stackoverflow.com/questions/24007650/selector-in-swift
    @discardableResult
    open func onChange(_ command: @escaping (MTabBar, UITabBarItem, Int) -> Void) -> Self {
        onChange = command
        return self
    }

    public func selectTab(index: Int) {
        let item = items[index]
        selectedItem = item
        performChange(item: item)
    }

    private func performChange(item: UITabBarItem) {
        if let callback = self.onChange, let index = items.index(of: item) {
            callback(self, item, index)
        }
    }
}

extension MTabBar: MDCTabBarDelegate {
    public func tabBar(_ tabBar: MDCTabBar, didSelect item: UITabBarItem) {
        performChange(item: item)
    }

    public func tabBar(_ tabBar: MDCTabBar, shouldSelect item: UITabBarItem) -> Bool {
        return item.isEnabled
    }
}

#endif
