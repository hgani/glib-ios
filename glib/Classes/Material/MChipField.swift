#if INCLUDE_MDLIBS

import MaterialComponents.MaterialChips

class MChipField: MDCChipField {
    fileprivate var helper: ViewHelper!
    private var onClick: ((MChipField) -> Void)?
    private var onEdit: ((MChipField) -> Void)?
    
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
        showChipsDeleteButton = true
        contentEdgeInsets = UIEdgeInsets(top: contentEdgeInsets.top,
                                         left: 8,
                                         bottom: contentEdgeInsets.bottom,
                                         right: 8)
        layer.borderWidth = 1
        layer.borderColor = UIColor.gray.cgColor
        layer.cornerRadius = 4
        
        var frame = UIScreen.main.bounds
        frame.size = sizeThatFits(frame.size)
        self.frame = frame

        self.delegate = self
    }
    
    public func placeholder(_ text: String) -> Self {
        textField.placeholderLabel.text = text
        return self
    }
    
    @discardableResult
    open func onClick(_ command: @escaping (MChipField) -> Void) -> Self {
        onClick = command
        textField.addTarget(self, action: #selector(performClick), for: .editingDidBegin)
        return self
    }
    
    @objc open func performClick() {
        if let callback = self.onClick {
            callback(self)
        }
    }

    @discardableResult
    open func onEdit(_ command: @escaping (MChipField) -> Void) -> Self {
        onEdit = command
        return self
    }

    private func performEdit() {
        if let callback = self.onEdit {
            callback(self)
        }
    }

    // Needed for helper.width() and helper.height()
    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        helper.didMoveToSuperview()
    }
}

extension MChipField: MDCChipFieldDelegate {
    func chipField(_ chipField: MDCChipField, didAddChip chip: MDCChipView) {
        performEdit()
    }

    func chipField(_ chipField: MDCChipField, didRemoveChip chip: MDCChipView) {
        performEdit()
    }
}

extension MChipField: IView {
    public var sizingHelper: SizingHelper {
        return helper
    }

    public var size: CGSize {
        return helper.size
    }

    @discardableResult
    public func color(bg: UIColor) -> Self {
        backgroundColor = bg
        return self
    }

    @discardableResult
    public func paddings(top: Float? = nil, left: Float? = nil, bottom: Float? = nil, right: Float? = nil) -> Self {
        helper.paddings(t: top, l: left, b: bottom, r: right)
        return self
    }

    @discardableResult
    public func width(_ width: Int) -> Self {
        helper.width(width)
        return self
    }

    @discardableResult
    public func width(_ width: LayoutSize) -> Self {
        helper.width(width)
        return self
    }

    @discardableResult
    public func height(_ height: Int) -> Self {
        helper.height(height)
        return self
    }

    @discardableResult
    public func height(_ height: LayoutSize) -> Self {
        helper.height(height)
        return self
    }
}

#endif
