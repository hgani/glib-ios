#if INCLUDE_MDLIBS

import MaterialComponents.MaterialButtons

class MFloatingButton: MDCFloatingButton {
    private var onClick: ((MFloatingButton) -> Void)?

    init() {
        super.init(frame: .zero, shape: .default)
        initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(frame: .zero, shape: .default)
        initialize()
    }

    private func initialize() {}

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
}

#endif
