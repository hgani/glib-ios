#if INCLUDE_MDLIBS

import MBRadioCheckboxButton2

class JsonView_Fields_Radio: JsonView, RadioButtonDelegate {
    private let radio = MRadio()
    private var onClick: ((JsonView_Fields_Radio) -> Void)?

    var value: String {
        return radio.isOn ? spec["value"].stringValue : ""
    }

    override func initView() -> UIView {
        return radio.delegate(self)
            .width(.matchParent)
            .title(spec["label"].stringValue)
    }

    public func checked(_ checked: Bool) {
        radio.isOn = checked
    }

    public func onClick(_ command: @escaping (JsonView_Fields_Radio) -> Void) {
        onClick = command
    }

    func radioButtonDidSelect(_ button: RadioButton) {
        if let callback = self.onClick {
            callback(self)
        }
    }

    func radioButtonDidDeselect(_ button: RadioButton) {}
}

class MRadio: RadioButton {
    fileprivate var helper: ViewHelper!

    init() {
        super.init(frame: .zero)
        initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    private func initialize() {
        helper = ViewHelper(self)
    }

    func title(_ str: String) -> Self {
        setTitle(str, for: [])
        setTitleColor(.black, for: [])
        titleLabel?.font = RobotoFonts.Style.regular.font
        return self
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

    func delegate(_ delegate: RadioButtonDelegate) -> Self {
        self.delegate = delegate
        return self
    }
}

extension MRadio: IView {
    public var sizingHelper: SizingHelper {
        return helper
    }

    public var size: CGSize {
        return helper.size
    }

    @discardableResult
    public func paddings(top: Float?, left: Float?, bottom: Float?, right: Float?) -> Self {
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
