#if INCLUDE_MDLIBS

import MaterialComponents.MaterialButtons

class MFloatingButton: MDCFloatingButton {
    fileprivate var helper: ViewHelper!
    private var onClick: ((MFloatingButton) -> Void)?

    init() {
        super.init(frame: .zero, shape: .default)
        initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(frame: .zero, shape: .default)
        initialize()
    }

    private func initialize() {
        helper = ViewHelper(self)
    }

    func icon(_ name: String) -> Self {
        let image = UIImage(from: .materialIcon,
                            code: name,
                            textColor: .white,
                            backgroundColor: .clear,
                            size: CGSize(width: 24, height: 24))
        setImage(image, for: .normal)

        return self
    }

    @discardableResult
    open func onClick(_ command: @escaping (MFloatingButton) -> Void) -> Self {
        onClick = command
        addTarget(self, action: #selector(performClick), for: .touchUpInside)
        return self
    }

    @discardableResult
    public func enabled(_ value: Bool) -> Self {
        isEnabled = value
        alpha = value ? 1.0 : 0.5
        return self
    }

    @objc open func performClick() {
        if let callback = self.onClick {
            callback(self)
        }
    }

    @discardableResult
    public func color(bg: UIColor?, text: UIColor? = nil) -> Self {
        if let bgColor = bg {
            backgroundColor = bgColor
        }
        if let textColor = text {
            setTitleColor(textColor, for: .normal)
        }
        return self
    }
}

extension MFloatingButton: IView {
    public var size: CGSize {
        return helper.size
    }

    @discardableResult
    public func paddings(top: Float?, left: Float?, bottom: Float?, right: Float?) -> Self {
//        paddings = paddings.to(top: top, left: left, bottom: bottom, right: right)
//        contentEdgeInsets = paddings.toEdgeInsets()
        helper.paddings(t: top, l: left, b: bottom, r: right)
        return self
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
    public func color(bg: UIColor) -> Self {
        return color(bg: bg, text: nil)
    }
}

#endif
