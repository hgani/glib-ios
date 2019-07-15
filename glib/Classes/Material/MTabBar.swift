import MaterialComponents.MaterialTabs

open class MTabBar: MDCTabBar {
    private var helper: ViewHelper!
    private var retainedRef: MDCTabBarDelegate?

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

    public func color(bg: UIColor?, text: UIColor? = nil) -> Self {
        if let bgColor = bg {
            backgroundColor = bgColor
        }
        if let textColor = text {
            setTitleColor(textColor, for: .normal)
        }
        return self
    }

    public func delegate(_ delegate: MDCTabBarDelegate, retain: Bool = false) -> Self {
        self.delegate = delegate
        if retain {
            retainedRef = delegate
        }
        return self
    }
}
