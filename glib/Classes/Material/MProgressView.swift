import MaterialComponents.MaterialProgressView

open class MProgressView: MDCProgressView {
    fileprivate var helper: ViewHelper!

    public var size: CGSize {
        return helper.size
    }

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

    public func progress(_ value: Float) -> Self {
        self.progress = value
        return self
    }

    public func hidden(_ value: Bool) -> Self {
        self.setHidden(value, animated: true)
        return self
    }
}
