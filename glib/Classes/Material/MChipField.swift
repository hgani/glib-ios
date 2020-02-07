#if INCLUDE_MDLIBS

import MaterialComponents.MaterialChips

class MChipField: MDCChipField {
    fileprivate var helper: ViewHelper!
    private var onClick: ((MChipField) -> Void)?
    
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
    
    public func paddings(top: Float?, left: Float?, bottom: Float?, right: Float?) -> Self {
        helper.paddings(t: top, l: left, b: bottom, r: right)
        return self
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
}

#endif
