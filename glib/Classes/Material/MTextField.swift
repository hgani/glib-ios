#if INCLUDE_MDLIBS

import MaterialComponents.MaterialTextControls_FilledTextFields
import MaterialComponents.MaterialTextControls_OutlinedTextFields

open class MTextField: GControl, ITextField {
//    private var helper: ViewHelper!
//    private var padding = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
    private var padding = UIEdgeInsets.zero

    // TODO: Make sure this doesn't generate cyclic references
//    private var controller: MDCTextInputController!

//    private var backend: MDCBaseTextField!

    private var onBeginEditing: ((MTextField) -> Void)?

    // See https://github.com/material-components/material-components-ios/issues/7133
    private var backend: MDCBaseTextField = MDCFilledTextField()

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

//    // TODO: Should wrap this in onBeginEditing() etc instead
//    public var delegate: UITextFieldDelegate? {
//        get {
//            return backend.delegate
//        }
//        set {
//            backend.delegate = newValue
//        }
//    }

    public var labelView: UILabel {
        return backend.label
    }

    public var hintView: UILabel {
        return backend.leadingAssistiveLabel
    }

    public var errorView: UILabel {
        return backend.trailingAssistiveLabel
    }

    public var isSecureTextEntry: Bool {
        return backend.isSecureTextEntry
    }

    public var trailingView: UIView? {
        return backend.trailingView
    }

    public override var inputView: UIView? {
        get {
            return backend.inputView
        }
        set {
            backend.inputView = newValue
        }
    }

    public override var inputAccessoryView: UIView? {
        get {
            return backend.inputAccessoryView
        }
        set {
            backend.inputAccessoryView = newValue
        }
    }

    public init(outlined: Bool) {
        super.init()
        if outlined {
//            backend = MDCOutlinedTextField(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
            backend = MDCOutlinedTextField()
        }
        initialize()
    }

    public override init() {
        super.init()
        initialize()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }

    private func initialize() {
        backend.delegate = self

        withView(backend, matchParent: true)
    }

    @discardableResult
    func rounded() -> Self {
        backend.layer.cornerRadius = 16
        return self
    }

    public func specs(_ specs: MTextFieldSpec...) -> Self {
        for spec in specs {
            spec.decorate(self)
        }
        return self
    }

    public func trailingView(_ view: UIView) -> Self {
        backend.trailingViewMode = .always
        backend.trailingView = view
//        backend.translatesAutoresizingMaskIntoConstraints = false
//        backend.rightViewMode = .always
        return self
    }

    open override func addTarget(_ target: Any?, action: Selector, for controlEvents: UIControl.Event) {
        backend.addTarget(target, action: action, for: controlEvents)
    }

    public func paddings(top: Float?, left: Float?, bottom: Float?, right: Float?) -> Self {
        // TODO
//        helper.paddings(t: top, l: left, b: bottom, r: right)
        return self
    }

    open override func resignFirstResponder() -> Bool {
        return backend.resignFirstResponder()
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
    public func secure(_ secure: Bool) -> Self {
        backend.isSecureTextEntry = secure
        return self
    }

    public func keyboardType(_ type: UIKeyboardType) -> Self {
        backend.keyboardType = type
        return self
    }

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

extension MTextField: UITextFieldDelegate {
    open func onBeginEditing(_ command: @escaping (MTextField) -> Void) {
        onBeginEditing = command
    }

    public func textFieldDidBeginEditing(_ textField: UITextField) {
        if let callback = onBeginEditing {
            callback(self)
        }
    }
}

#endif
