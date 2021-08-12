#if INCLUDE_MDLIBS

import MaterialComponents.MaterialTextControls_FilledTextFields
import MaterialComponents.MaterialTextControls_FilledTextFieldsTheming
import MaterialComponents.MaterialTextControls_OutlinedTextFields
import MaterialComponents.MaterialTextControls_OutlinedTextFieldsTheming

open class MTextField: GControl {
    private var padding = UIEdgeInsets.zero

    private var onEdit: ((MTextField) -> Void)?

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

    public var label: String? {
        get {
            return labelView.text
        }
        set {
            labelView.text = newValue
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

    // Don't override inputAccessoryView because it causes a crash when UIKit performs its own
    // internal initialization.
    public var backendInputAccessoryView: UIView? {
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

    public func themeScheme(_ scheme: MDCContainerScheme) {
        if let view = backend as? MDCOutlinedTextField {
            view.applyTheme(withScheme: scheme)
        } else if let view = backend as? MDCFilledTextField {
            view.applyTheme(withScheme: scheme)
        } else {
            fatalError("Unsupported operation")
        }
    }

    public func trailingView(_ view: UIView) -> Self {
        backend.trailingViewMode = .always
        backend.trailingView = view
//        backend.translatesAutoresizingMaskIntoConstraints = false
//        backend.rightViewMode = .always
        return self
    }

    // Cannot use ControlHelper because `backend` is not a UIControl.
    func onEdit(_ command: @escaping (MTextField) -> Void) -> Self {
        onEdit = command
        backend.addTarget(self, action: #selector(performEdit), for: .editingChanged)
        return self
    }

    @objc open func performEdit() {
        if let callback = self.onEdit {
            callback(self)
        }
    }
    
//    open override func addTarget(_ target: Any?, action: Selector, for controlEvents: UIControl.Event) {
//        backend.addTarget(target, action: action, for: controlEvents)
//    }

    open override func resignFirstResponder() -> Bool {
        return backend.resignFirstResponder()
    }

    func readOnly(_ value: Bool) -> Self {
        isUserInteractionEnabled = !value
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
//    public override func color(bg: UIColor) -> Self {
//        backend.backgroundColor = bg
//        return self
//    }

    public func secure(_ secure: Bool) -> Self {
        backend.isSecureTextEntry = secure
        return self
    }

    public func keyboardType(_ type: UIKeyboardType) -> Self {
        backend.keyboardType = type
        return self
    }

    public func text(_ text: String) -> Self {
        self.text = text
        return self
    }

    public func label(_ str: String) -> Self {
        label = str
        return self
    }

    public func placeholder(_ str: String) -> Self {
        placeholder = str
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
