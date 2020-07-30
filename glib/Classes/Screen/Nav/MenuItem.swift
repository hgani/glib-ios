public class MenuItem {
    public private(set) var title: String?
    public private(set) var icon: GIcon?
    private(set) var controller: UIViewController?
    private(set) var onClick: (() -> Void)?

    private(set) var isRoot = false
    private(set) var cellClass: GTableViewCustomCell.Type = MenuCell.self

    public private(set) var iconSpec: Json?

    public init(title: String) {
        self.title = title
    }

    public init() {
        // Nothing to do
    }

    public func title(_ title: String) -> Self {
        self.title = title
        return self
    }

    public func icon(_ icon: GIcon) -> Self {
        self.icon = icon
        return self
    }

    public func iconSpec(_ spec: Json) -> Self {
        self.iconSpec = spec
        return self
    }

    public func root(_ root: Bool) -> Self {
        isRoot = root
        return self
    }

    public func screen(_ screen: GScreen) -> Self {
        controller = screen
        return self
    }

    public func onClick(_ onClick: @escaping () -> Void) -> Self {
        self.onClick = onClick
        return self
    }

    public func cellClass(_ cellClass: GTableViewCustomCell.Type) -> Self {
        self.cellClass = cellClass
        return self
    }

    public func hasAction() -> Bool {
        return controller != nil || onClick != nil
    }
}

#if INCLUDE_EUREKA

    extension MenuItem {
        public func screen(_ screen: GFormScreen) -> Self {
            controller = screen
            return self
        }
    }

#endif
