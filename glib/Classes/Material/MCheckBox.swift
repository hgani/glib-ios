#if INCLUDE_MDLIBS

import MBRadioCheckboxButton2

class MCheckBox: CheckboxButton {
    fileprivate var helper: ViewHelper!

    init() {
        super.init(frame: .zero)
        initialize()
    }

    required public init?(coder aDecoder: NSCoder) {
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

    func delegate(_ delegate: CheckboxButtonDelegate) -> Self {
        self.delegate = delegate
        return self
    }
}

extension MCheckBox: IView {
    public var size: CGSize {
        return helper.size
    }

    @discardableResult
    public func paddings(top: Float?, left: Float?, bottom: Float?, right: Float?) -> Self {
        helper.paddings(t: top, l: left, b: bottom, r: right)

//        paddings = paddings.to(top: top, left: left, bottom: bottom, right: right)
//        contentEdgeInsets = paddings.toEdgeInsets()
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
