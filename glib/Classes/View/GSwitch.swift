import UIKit

open class GSwitch: UISwitch {
    private var helper: ViewHelper!
    private var onClick: ((GSwitch) -> Void)?

    public init() {
        super.init(frame: .zero)

        helper = ViewHelper(self)
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    public func width(_ width: Int) -> Self {
        helper.width(width)
        return self
    }

    public func height(_ height: Int) -> Self {
        helper.height(height)
        return self
    }

    public func color(bg: UIColor?, text _: UIColor? = nil) -> Self {
        if let bgColor = bg {
            backgroundColor = bgColor
        }
        return self
    }

    public func checked(_ check: Bool) -> Self {
        isOn = check
        return self
    }

    @discardableResult
    open func onClick(_ command: @escaping (GSwitch) -> Void) -> Self {
        onClick = command
        addTarget(self, action: #selector(performClick), for: .touchUpInside)
        return self
    }

    @objc open func performClick() {
        if let callback = self.onClick {
            callback(self)
        }
    }

    public func end() {
        // End chaining initialisation
    }
}
