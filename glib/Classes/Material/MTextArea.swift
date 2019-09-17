import MaterialComponents.MaterialTextFields

open class MTextArea: MDCMultilineTextField {
    private var helper: ViewHelper!
    private var padding = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
    // TODO: Make sure this doesn't generate cyclic references
    private var controller: MDCTextInputController!

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
        controller = MDCTextInputControllerFilled(textInput: self)
    }

    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        helper.didMoveToSuperview()
    }

    public func placeholder(_ str: String) -> Self {
        controller.placeholderText = str
        return self
    }

    public func hint(_ str: String) -> Self {
        controller.helperText = str
        return self
    }

    public func paddings(top: Float?, left: Float?, bottom: Float?, right: Float?) -> Self {
        helper.paddings(t: top, l: left, b: bottom, r: right)
        return self
    }

    public func color(bg: UIColor) -> Self {
        return color(bg: bg, text: nil)
    }

    public func color(bg: UIColor?, text: UIColor? = nil) -> Self {
        if let bgColor = bg {
            backgroundColor = bgColor
        }
        if let textColor = text {
            self.textColor = textColor
        }
        return self
    }

    public func border(color: UIColor?, width: Float = 1, corner: Float = 6) -> Self {
        helper.border(color: color, width: width, corner: corner)
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

    public func specs(_ specs: MTextAreaSpec...) -> Self {
        for spec in specs {
            spec.decorate(self)
        }
        return self
    }

    public func text(_ text: String) -> Self {
        self.text = text
        return self
    }

    public func maxLength(_ value: UInt) -> Self {
        controller.characterCountMax = value
        return self
    }

    public func maxLength() -> UInt {
        return controller.characterCountMax
    }
}

public class MTextAreaSpec {
    private var decorator: ((MTextArea) -> Void)

    public init(_ decorator: @escaping ((MTextArea) -> Void)) {
        self.decorator = decorator
    }

    func decorate(_ view: MTextArea) {
        decorator(view)
    }
}
