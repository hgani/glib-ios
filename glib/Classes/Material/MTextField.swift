#if INCLUDE_MDLIBS

import MaterialComponents.MaterialTextControls_OutlinedTextFields

// See https://github.com/material-components/material-components-ios/issues/7133
open class MTextField: GControl, ITextField {
//    private var helper: ViewHelper!
//    private var padding = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
    private var padding = UIEdgeInsets.zero

    // TODO: Make sure this doesn't generate cyclic references
//    private var controller: MDCTextInputController!

    private var backend: MDCOutlinedTextField!

    public var text: String? {
        get {
            return backend.text
        }
        set {
            backend.text = newValue
        }
    }

    public var placeholder: String? {
        get {
            return backend.placeholder
        }
        set {
            backend.placeholder = newValue
        }
    }

    public var labelView: UILabel {
        return backend.label
    }

    public var hintView: UILabel {
        return backend.leadingAssistiveLabel
    }
//
//    public var size: CGSize {
//        return helper.size
//    }
//
//    public init() {
//        super.init(frame: .zero)
//        initialize()
//    }
//
//    public required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        initialize()
//    }

    public override init() {
        super.init()
        initialize()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }

    private func initialize() {
        // Try https://github.com/material-components/material-components-ios/issues/7133

//        backend = MDCOutlinedTextField(frame: CGRect(x: 0, y: 0, width: 300, height: 50))
        backend = MDCOutlinedTextField()

//        backend.backgroundColor = .blue

//        backend.label.text = "Label"
//        backend.text = "This is text"
//        backend.placeholder = "555-555-5555"
//        backend.leadingAssistiveLabel.text = "This is helper text"
        backend.sizeToFit()

//        width(.matchParent).color(bg: .green).append(backend)
        withView(backend, matchParent: true)
    }

    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
//        helper.didMoveToSuperview()
    }

    public func specs(_ specs: MTextFieldSpec...) -> Self {
        for spec in specs {
            spec.decorate(self)
        }
        return self
    }

//    public func placeholder(_ str: String) -> Self {
//        controller.placeholderText = str
//        return self
//    }
//
//    public func hint(_ str: String) -> Self {
//        controller.helperText = str
//        return self
//    }

    open override func addTarget(_ target: Any?, action: Selector, for controlEvents: UIControl.Event) {
        backend.addTarget(target, action: action, for: controlEvents)
    }

    public func paddings(top: Float?, left: Float?, bottom: Float?, right: Float?) -> Self {
        // TODO
//        helper.paddings(t: top, l: left, b: bottom, r: right)
        return self
    }
//
//    open override func textRect(forBounds bounds: CGRect) -> CGRect {
//        return bounds.inset(by: padding)
////        return UIEdgeInsetsInsetRect(bounds, padding)
//    }
//
//    open override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
//        return bounds.inset(by: padding)
////        return UIEdgeInsetsInsetRect(bounds, padding)
//    }
//
//    open override func editingRect(forBounds bounds: CGRect) -> CGRect {
//        return bounds.inset(by: padding)
////        return UIEdgeInsetsInsetRect(bounds, padding)
//    }
//
//    public func color(bg: UIColor) -> Self {
//        return color(bg: bg, text: nil)
//    }
//
//    public func color(bg: UIColor?, text: UIColor? = nil) -> Self {
//        if let bgColor = bg {
//            backgroundColor = bgColor
//        }
//        if let textColor = text {
//            self.textColor = textColor
//        }
//        return self
//    }
//
//    public func border(color: UIColor?, width: Float = 1, corner: Float = 6) -> Self {
//        helper.border(color: color, width: width, corner: corner)
//        return self
//    }
//
//    public func width(_ width: Int) -> Self {
//        helper.width(width)
//        return self
//    }
//
//    public func width(_ width: LayoutSize) -> Self {
//        helper.width(width)
//        return self
//    }
//
//    public func height(_ height: Int) -> Self {
//        helper.height(height)
//        return self
//    }
//
//    public func height(_ height: LayoutSize) -> Self {
//        helper.height(height)
//        return self
//    }
//
////    public func specs(_ specs: MTextFieldSpec...) -> Self {
////        for spec in specs {
////            spec.decorate(self)
////        }
////        return self
////    }
//
    public func secure(_ secure: Bool) -> Self {
        backend.isSecureTextEntry = secure
        return self
    }

    public func keyboardType(_ type: UIKeyboardType) -> Self {
        backend.keyboardType = type
        return self
    }
//
//    public func text(_ text: String) -> Self {
//        self.text = text
//        return self
//    }
//
//    public func errors(_ text: String?) -> Self {
//        controller.setErrorText(text, errorAccessibilityValue: nil)
//        return self
//    }
//
//    public func trailingViewMode(_ mode: UITextField.ViewMode) -> Self {
//        self.trailingViewMode = mode
//        return self
//    }
}

//class MDCTextInputControllerRoundedOutlined: MDCTextInputControllerOutlined {
//    @objc func updateBorder() {
//        let superClass = class_getSuperclass(type(of: self))
//        let selector = #selector(updateBorder)
//
//        let impl = class_getMethodImplementation(superClass, selector)
//        typealias ObjCVoidVoidFn = @convention(c) (AnyObject, Selector) -> Void
//        let fn = unsafeBitCast(impl, to: ObjCVoidVoidFn.self)
//        fn(self, selector)
//    }
//}

#endif
